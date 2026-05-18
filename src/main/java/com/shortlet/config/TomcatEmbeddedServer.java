package com.shortlet.config;

import com.shortlet.filter.AuthenticationFilter;
import com.shortlet.servlet.AdminDashboardServlet;
import com.shortlet.servlet.ErrorServlet;
import com.shortlet.servlet.ExportExcelServlet;
import com.shortlet.servlet.ForgotPasswordServlet;
import com.shortlet.servlet.GoogleOAuthCallbackServlet;
import com.shortlet.servlet.LandingServlet;
import com.shortlet.servlet.LoginServlet;
import com.shortlet.servlet.SearchServlet;
import com.shortlet.servlet.LogoutServlet;
import com.shortlet.servlet.SignupServlet;
import com.shortlet.servlet.UserDashboardServlet;
import com.shortlet.servlet.PropertyMarkersServlet;
import com.shortlet.servlet.SearchSuggestionServlet;
import com.shortlet.servlet.WishlistToggleServlet;
import com.shortlet.servlet.JijiInquiryServlet;
import com.shortlet.servlet.ForgotPasswordServlet;
import com.shortlet.servlet.GoogleOAuthCallbackServlet;
import com.shortlet.servlet.LandingServlet;
import com.shortlet.servlet.LoginServlet;
import com.shortlet.servlet.SearchServlet;
import com.shortlet.servlet.LogoutServlet;
import com.shortlet.servlet.SignupServlet;
import org.apache.catalina.Context;
import org.apache.catalina.Wrapper;
import org.apache.catalina.startup.Tomcat;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.CodeSource;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;

public class TomcatEmbeddedServer {
    public static void main(String[] args) throws Exception {
        int port = Integer.parseInt(System.getenv().getOrDefault("PORT", "8080"));

        // Development logic: Use src/main/webapp directly if it exists for instant JSP updates
        Path webappPath = Path.of("src/main/webapp");
        if (!Files.exists(webappPath)) {
            webappPath = extractWebapp();
        }

        Tomcat tomcat = new Tomcat();
        tomcat.setPort(port);
        tomcat.getConnector();

        Context context = tomcat.addWebapp("", webappPath.toAbsolutePath().toString());
        context.addApplicationListener(AppStartupListener.class.getName());
        context.setSessionCookieName("SHORTLET_SESSION");

        addServlet(context, "landing", new LandingServlet(), "");
        context.addServletMappingDecoded("/home", "landing");
        context.addServletMappingDecoded("/index", "landing");
        addServlet(context, "search", new SearchServlet(), "/search");
        addServlet(context, "login", new LoginServlet(), "/login");
        context.addServletMappingDecoded("/login.jsp", "login");
        addServlet(context, "signup", new SignupServlet(), "/signup");
        context.addServletMappingDecoded("/register", "signup");
        context.addServletMappingDecoded("/signup.jsp", "signup");
        addServlet(context, "googleCallback", new GoogleOAuthCallbackServlet(), "/oauth2/google/callback");
        addServlet(context, "userDashboard", new UserDashboardServlet(), "/dashboard");
        addServlet(context, "adminDashboard", new AdminDashboardServlet(), "/admin");
        addServlet(context, "exportExcel", new ExportExcelServlet(), "/admin/export.xlsx");
        addServlet(context, "logout", new LogoutServlet(), "/logout");
        addServlet(context, "error", new ErrorServlet(), "/error");
        addServlet(context, "propertyMarkers", new PropertyMarkersServlet(), "/api/properties/markers");
        addServlet(context, "searchSuggestion", new SearchSuggestionServlet(), "/api/search/suggest");
        addServlet(context, "wishlistToggle", new WishlistToggleServlet(), "/wishlist/toggle");
        addServlet(context, "jijiInquiry", new JijiInquiryServlet(), "/inquire");
        addServlet(context, "forgotPassword", new ForgotPasswordServlet(), "/forgot-password");
        addServlet(context, "googleLoginAlias", new LoginServlet(), "/oauth2/authorization/google");

        context.addFilterDef(AuthenticationFilter.definition());
        context.addFilterMap(AuthenticationFilter.map("/dashboard"));
        context.addFilterMap(AuthenticationFilter.map("/wishlist/toggle"));
        context.addFilterMap(AuthenticationFilter.map("/inquire"));
        context.addFilterMap(AuthenticationFilter.map("/admin"));
        context.addFilterMap(AuthenticationFilter.map("/admin/*"));

        context.addErrorPage(errorPage(404, "/error?code=404"));
        context.addErrorPage(errorPage(403, "/error?code=403"));
        context.addErrorPage(errorPage(500, "/error?code=500"));

        tomcat.start();
        System.out.println("Shortlet running at http://localhost:" + port);
        tomcat.getServer().await();
    }

    private static void addServlet(Context context, String name, jakarta.servlet.Servlet servlet, String mapping) {
        Wrapper wrapper = Tomcat.addServlet(context, name, servlet);
        wrapper.setLoadOnStartup(1);
        context.addServletMappingDecoded(mapping, name);
    }

    private static org.apache.tomcat.util.descriptor.web.ErrorPage errorPage(int code, String location) {
        org.apache.tomcat.util.descriptor.web.ErrorPage errorPage = new org.apache.tomcat.util.descriptor.web.ErrorPage();
        errorPage.setErrorCode(code);
        errorPage.setLocation(location);
        return errorPage;
    }

    private static Path extractWebapp() throws IOException, URISyntaxException {
        Path target = Files.createTempDirectory("shortlet-webapp-");
        CodeSource codeSource = TomcatEmbeddedServer.class.getProtectionDomain().getCodeSource();
        if (codeSource == null) {
            return target;
        }
        URI location = codeSource.getLocation().toURI();
        Path source = Path.of(location);
        if (Files.isDirectory(source)) {
            Path sourceWebapp = source.resolve("webapp");
            if (Files.exists(sourceWebapp)) {
                copyDirectory(sourceWebapp, target);
            }
        } else {
            try (JarFile jarFile = new JarFile(source.toFile())) {
                var entries = jarFile.entries();
                while (entries.hasMoreElements()) {
                    JarEntry entry = entries.nextElement();
                    if (!entry.getName().startsWith("webapp/") || entry.isDirectory()) {
                        continue;
                    }
                    Path output = target.resolve(entry.getName().substring("webapp/".length()));
                    Files.createDirectories(output.getParent());
                    try (var input = jarFile.getInputStream(entry)) {
                        Files.copy(input, output);
                    }
                }
            }
        }
        return target;
    }

    private static void copyDirectory(Path source, Path target) throws IOException {
        try (var paths = Files.walk(source)) {
            for (Path path : paths.toList()) {
                Path destination = target.resolve(source.relativize(path).toString());
                if (Files.isDirectory(path)) {
                    Files.createDirectories(destination);
                } else {
                    Files.createDirectories(destination.getParent());
                    Files.copy(path, destination);
                }
            }
        }
    }
}
