package sentencecraft.sentencecraft;

/**
 * Created by zqiu on 4/27/16.
 * Class meant to store globally accessible data accessible by others
 */
public class GlobalValues {

    public static boolean lexemeIsWord = true;
    public static boolean networkIsLocalhost = true;

    public static String getBaseURL() {
        String base;
        if(networkIsLocalhost){
            base = "10.0.2.2";
        }else{
            base = "128.113.151.26";
        }
        return "http://"+base+":5000/";
    }

    public static String getStartSentenceExtension() {
        return "start/";
    }

    public static String getContinueSentenceRequest() {
        return "incomplete/";
    }

    public static String getContinueSentencePost() {
        return "append/";
    }

    public static String getViewExtension(){
        return "view/";
    }

    public static String getTypeExtension(){
        return "type=" + getLexeme();
    }

    public static String getLexeme(){
        if(lexemeIsWord){
            return "word";
        }else{
            return "sentence";
        }
    }

    public static String getLexemeCollection(){
        if(lexemeIsWord){
            return "sentence";
        }else{
            return "paragraph";
        }
    }
}
