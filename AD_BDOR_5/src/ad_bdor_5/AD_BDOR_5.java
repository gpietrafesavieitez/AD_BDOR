package ad_bdor_5;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class AD_BDOR_5 {

    public static Connection conn = null;

    public void conectar() throws SQLException {
        String driver = "jdbc:oracle:thin:",
                host = "localhost",
                porto = "1521",
                sid = "orcl",
                usuario = "hr",
                password = "hr",
                url = driver + usuario + "/" + password + "@" + host + ":" + porto + ":" + sid;
        conn = DriverManager.getConnection(url);
    }

    public void desconectar() throws SQLException {
        conn.close();
    }

    public void insireLinea(int ordnum, int linum, int item, int cantidad, int descuento) throws SQLException {
        String sql = "INSERT INTO THE (SELECT P.pedido FROM pedido_tab P WHERE P.ordnum=?) SELECT ?, REF(S), ?, ? FROM item_tab S WHERE S.itemnum=?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, ordnum);
        ps.setInt(2, linum);
        ps.setInt(3, cantidad);
        ps.setInt(4, descuento);
        ps.setInt(5, item);
        ps.executeUpdate();
    }

    public void modificaLinea(String clinomb, int clinum) throws SQLException {
        String sql = "UPDATE cliente_tab SET clinomb=? WHERE clinum=?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, clinomb);
        ps.setInt(2, clinum);
        ps.executeUpdate();
    }

    public void borraLinea(int ordnum, int linum) throws SQLException {
        String sql = "DELETE FROM THE (SELECT P.pedido FROM pedido_tab P WHERE P.ordnum=?) WHERE linum=?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, ordnum);
        ps.setInt(2, linum);
        ps.executeUpdate();
    }

    public static void main(String[] args) throws SQLException {
        AD_BDOR_5 obj = new AD_BDOR_5();
        obj.conectar();
        obj.insireLinea(4001, 48, 2004, 20, 10);
        obj.modificaLinea("Alvaro Luna", 5);
        obj.borraLinea(4001, 42);
        obj.desconectar();
    }
}
