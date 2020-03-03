/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ad_bdor_3;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Struct;

/**
 *
 * @author oracle
 */
public class AD_BDOR_3 {

    public static Connection conn;

    public static Connection conexion() throws SQLException {
        String driver = "jdbc:oracle:thin:",
                host = "localhost.localdomain",
                porto = "1521",
                sid = "orcl",
                usuario = "hr",
                password = "hr",
                url = driver + usuario + "/" + password + "@" + host + ":" + porto + ":" + sid;
        return DriverManager.getConnection(url);
    }

    public static void main(String[] args) throws SQLException {
        conn = conexion();
        ResultSet rs = conn.createStatement().executeQuery("SELECT * FROM empregadosbdor");
        System.out.println("id\t\ttipo_emp (obj)\t\tsalario");
        System.out.println("\t\tnome\tedade\t\t");
        while(rs.next()){
            Struct x = (Struct) rs.getObject(2);
            Object[] campos = x.getAttributes();
            String z = (String) campos[0];
            java.math.BigDecimal y = (java.math.BigDecimal) campos[1];
            System.out.println(rs.getInt(1) + "\t\t" + z + "\t" + y + "\t\t" + rs.getInt(3));
        }
        
        conn.close();

    }

}
