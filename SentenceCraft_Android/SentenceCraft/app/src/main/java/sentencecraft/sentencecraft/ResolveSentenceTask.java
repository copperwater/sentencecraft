package sentencecraft.sentencecraft;

import android.content.Context;
import android.support.design.widget.Snackbar;
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
    private String operationName = "continue sentence";

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
            wr.writeBytes("addition=" + lexemeToAdd);
            wr.writeBytes("&complete=" + isComplete);
            wr.writeBytes("&key=" + key);
            wr.writeBytes("&"+GlobalMethods.getTypeExtension());
            wr.flush();
            wr.close();
        }
    }

    @Override
    protected void onPostExecute(String result) {
        Snackbar mySnackBar;
        if(getResponseCode() == 200){
            mySnackBar = Snackbar.make(rootView,context.getString(R.string.sucess_operation,operationName), Snackbar.LENGTH_SHORT);
            mySnackBar.show();
        }else{
            mySnackBar = Snackbar.make(rootView,context.getString(R.string.error_operation_not_complete,operationName), Snackbar.LENGTH_LONG);
            mySnackBar.show();
            mySnackBar.setText(result);
            mySnackBar.show();
        }
    }
}