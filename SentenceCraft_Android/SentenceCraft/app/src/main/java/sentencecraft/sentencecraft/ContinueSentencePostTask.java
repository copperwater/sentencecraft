package sentencecraft.sentencecraft;

import android.content.Context;
import android.support.design.widget.Snackbar;
import android.view.View;

import java.io.DataOutputStream;
import java.io.IOException;
import java.net.HttpURLConnection;

/**
 * Created by zqiu on 4/27/16.
 * Used to asynchronously post to incomplete sentences for the ContinueSentence Activity
 */
public class ContinueSentencePostTask extends DownloadInfoTask{

    private String lexemeToAdd = "";
    private String isComplete = "";
    private String key;

    //constructor. needs to be passed the key received from ContinueSentenceGetTask
    public ContinueSentencePostTask(View rootView, Context context, int editId, String key) {
        super(rootView, context, editId);
        this.key = key;
    }

    @Override
    protected String doInBackground(String... urls) {
        //error checking. We need 4 args. 3rd arg is lexemeToAdd
        //4th arg is whether to complete sentence or not
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
            //addition form data
            DataOutputStream wr = new DataOutputStream(conn.getOutputStream());
            wr.writeBytes("addition=" + lexemeToAdd);
            wr.writeBytes("&complete=" + isComplete);
            wr.writeBytes("&key=" + key);
            wr.writeBytes("&"+ GlobalValues.getTypeExtension());
            wr.flush();
            wr.close();
        }
    }

    @Override
    protected void onPostExecute(String result) {
        String operationName = "continue sentence";
        Snackbar mySnackBar;
        if(getResponseCode() == 200){
            mySnackBar = Snackbar.make(rootView,context.getString(R.string.success_operation,operationName), Snackbar.LENGTH_SHORT);
            mySnackBar.show();
        }else{
            //bad request from server let user know
            mySnackBar = Snackbar.make(rootView,context.getString(R.string.error_operation_not_complete,operationName), Snackbar.LENGTH_LONG);
            mySnackBar.show();
            mySnackBar.setText(result);
            mySnackBar.show();
        }
    }
}
