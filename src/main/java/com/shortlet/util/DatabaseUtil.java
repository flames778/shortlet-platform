package com.shortlet.util;

import org.h2.jdbcx.JdbcConnectionPool;

import java.sql.Connection;
import java.sql.SQLException;

public final class DatabaseUtil {
    private static JdbcConnectionPool pool;

    private DatabaseUtil() {
    }

    public static synchronized void init() {
        if (pool != null) {
            return;
        }
        pool = JdbcConnectionPool.create(
                AppConfig.get("db.url", "jdbc:h2:file:./data/shortlet;MODE=PostgreSQL;DATABASE_TO_LOWER=TRUE"),
                AppConfig.get("db.user", "sa"),
                AppConfig.get("db.password", "")
        );
        pool.setMaxConnections(20);
    }

    public static Connection getConnection() throws SQLException {
        if (pool == null) {
            init();
        }
        return pool.getConnection();
    }

    public static synchronized void shutdown() {
        if (pool != null) {
            pool.dispose();
            pool = null;
        }
    }
}
