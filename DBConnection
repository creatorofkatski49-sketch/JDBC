import io.github.cdimascio.dotenv.Dotenv;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static final Dotenv dotenv = Dotenv.load();

    public static Connection connect() {
        try {
            String host     = dotenv.get("DB_HOST");
            String port     = dotenv.get("DB_PORT");
            String name     = dotenv.get("DB_NAME");
            String user     = dotenv.get("DB_USER");
            String password = dotenv.get("DB_PASSWORD");

            String url = "jdbc:postgresql://" + host + ":" + port + "/" + name
                    + "?sslmode=require";  // Supabase requires SSL

            return DriverManager.getConnection(url, user, password);

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("aaa");
            return null;
        }
    }
}
