import javax.net.ssl.*;
import java.net.Socket;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;

public class TlsClient {
    public static void main(String[] args) throws Exception {
        System.setProperty("javax.net.debug", "ssl:handshake:verbose");
        SSLContext sslContext = SSLContext.getDefault();
        SSLSocketFactory ssf = sslContext.getSocketFactory();
        Socket s = ssf.createSocket("127.0.0.1", 9999);
        ((SSLSocket)s).getSession();
    }
}
