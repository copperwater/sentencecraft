package sentencecraft.sentencecraft;

/**
 * Created by zqiu on 4/27/16.
 */
public class GlobalMethods {

    public static boolean lexemeIsWord = true;

    public static String getBaseURL() {
        return "http://10.0.2.2:5000/";
    }

    public static String getStartSentenceExtension() {
        return "start";
    }

    public static String getContinueSentenceRequest() {
        return "incomplete";
    }

    public static String getContinueSentencePost() {
        return "append";
    }

    public static String getViewExtension(){
        return "view";
    }
}
