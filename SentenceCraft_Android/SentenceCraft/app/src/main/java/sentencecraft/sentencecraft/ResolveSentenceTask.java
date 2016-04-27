package sentencecraft.sentencecraft;

import android.content.Context;
import android.view.View;

import java.io.DataOutputStream;
import java.io.IOException;
import java.net.HttpURLConnection;

/**
 * Created by zqiu on 4/27/16.
 */
public class ResolveSentenceTask extends DownloadInfoTask{

    private String lexemeToAdd = "";
    private String isComplete = "";
    private String key;

    public ResolveSentenceTask(View rootView, Context context, int editId, String key) {
        super(rootView, context, editId);
        this.key = key;
    }

    protected String doInBackground(String... urls) {
        if(urls.length == 4){
            lexemeToAdd = urls[2];
            isComplete = urls[3];
            return super.doInBackground(urls);
        }else{
            return "arguments not recognized";
        }
    }

    @Override
    protected void sendAdditionalData(HttpURLConnection conn) throws IOException {
        if(key.equals("")){
            super.sendAdditionalData(conn);
        }else{
            DataOutputStream wr = new DataOutputStream(conn.getOutputStream());
            wr.writeBytes("sentence_addition=" + lexemeToAdd);
            wr.writeBytes("&complete=" + isComplete);
            wr.writeBytes("&key=" + key);
            wr.flush();
            wr.close();
        }
    }
}