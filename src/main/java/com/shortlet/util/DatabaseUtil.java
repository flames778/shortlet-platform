package com.shortlet.util;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.LinkedList;

public final class DatabaseUtil {
    private static org.h2.jdbcx.JdbcConnectionPool h2Pool;
    private static boolean isSQLite = false;
    private static String dbUrl;
    private static String dbUser;
    private static String dbPassword;

    private static final LinkedList<Connection> sqlitePool = new LinkedList<>();
    private static final int MAX_POOL_SIZE = 20;

    private DatabaseUtil() {
    }

    public static synchronized void init() {
        dbUrl = AppConfig.get("db.url", "jdbc:h2:file:./data/shortlet;MODE=PostgreSQL;DATABASE_TO_LOWER=TRUE");
        dbUser = AppConfig.get("db.user", "sa");
        dbPassword = AppConfig.get("db.password", "");

        if (dbUrl.startsWith("jdbc:sqlite:")) {
            isSQLite = true;
            try {
                Class.forName("org.sqlite.JDBC");
                ensureSQLiteDirectoryExists(dbUrl);
            } catch (ClassNotFoundException e) {
                throw new RuntimeException("SQLite JDBC Driver not found", e);
            } catch (java.io.IOException e) {
                throw new RuntimeException("Unable to create SQLite database directory", e);
            }
        } else {
            isSQLite = false;
            if (h2Pool == null) {
                h2Pool = org.h2.jdbcx.JdbcConnectionPool.create(dbUrl, dbUser, dbPassword);
                h2Pool.setMaxConnections(MAX_POOL_SIZE);
            }
        }
    }

    private static void ensureSQLiteDirectoryExists(String url) throws java.io.IOException {
        String path = url.substring("jdbc:sqlite:".length());
        if (path.isBlank() || path.equals(":memory:")) {
            return;
        }

        Path parent = Path.of(path).toAbsolutePath().getParent();
        if (parent != null) {
            Files.createDirectories(parent);
        }
    }

    public static Connection getConnection() throws SQLException {
        if (dbUrl == null) {
            init();
        }
        if (isSQLite) {
            return getSQLiteConnection();
        } else {
            return h2Pool.getConnection();
        }
    }

    private static synchronized Connection getSQLiteConnection() throws SQLException {
        while (!sqlitePool.isEmpty()) {
            Connection conn = sqlitePool.removeFirst();
            if (conn != null && !conn.isClosed() && conn.isValid(2)) {
                return wrapConnection(conn);
            }
        }
        Connection conn = DriverManager.getConnection(dbUrl);
        // Enable foreign key constraints for SQLite
        try (java.sql.Statement s = conn.createStatement()) {
            s.execute("PRAGMA foreign_keys = ON;");
        }
        return wrapConnection(conn);
    }

    private static synchronized void releaseSQLiteConnection(Connection conn) {
        if (conn == null) return;
        try {
            if (!conn.isClosed() && conn.isValid(2) && sqlitePool.size() < MAX_POOL_SIZE) {
                sqlitePool.addLast(conn);
            } else {
                conn.close();
            }
        } catch (SQLException e) {
            try { conn.close(); } catch (SQLException ignored) {}
        }
    }

    private static Connection wrapConnection(final Connection physicalConnection) {
        return (Connection) Proxy.newProxyInstance(
                DatabaseUtil.class.getClassLoader(),
                new Class<?>[]{Connection.class},
                new InvocationHandler() {
                    @Override
                    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                        if ("close".equals(method.getName())) {
                            DatabaseUtil.releaseSQLiteConnection(physicalConnection);
                            return null;
                        }
                        try {
                            return method.invoke(physicalConnection, args);
                        } catch (java.lang.reflect.InvocationTargetException e) {
                            throw e.getCause();
                        }
                    }
                }
        );
    }

    public static synchronized void shutdown() {
        if (h2Pool != null) {
            h2Pool.dispose();
            h2Pool = null;
        }
        for (Connection conn : sqlitePool) {
            try { conn.close(); } catch (SQLException ignored) {}
        }
        sqlitePool.clear();
        dbUrl = null;
    }
}
