package mytools;

import java.io.UnsupportedEncodingException;  
import org.apache.commons.codec.binary.Base64;
import sun.misc.BASE64Encoder;
public class Mybase64 {
	public Mybase64() {
		
	}
    public String encodebase(String str){  
        String strbase = "";  
        try{  
        	BASE64Encoder decoder = new BASE64Encoder();
        	strbase = decoder.encode( str.getBytes("UTF-8") );
//            byte[] encodeBase64 = BASE64Encoder(str.getBytes("UTF-8"));  
//            System.out.println("RESULT: " + new String(encodeBase64)); 
        } catch(UnsupportedEncodingException e){  
            e.printStackTrace();  
            strbase="error";
        }  
        return strbase;
    } 
}
