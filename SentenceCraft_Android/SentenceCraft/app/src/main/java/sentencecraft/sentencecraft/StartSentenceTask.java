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
public class StartSentenceTask extends DownloadInfoTask {

    private String lexeme;
    private String tags;
    private String operationName = "start";

    public StartSentenceTask(View rootView, Context context, int editId) {
        super(rootView, context, editId);
    }

    // onPostExecute displays the results of the AsyncTask.
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

    @Override
    protected void sendAdditionalData(HttpURLConnection conn) throws IOException {
        DataOutputStream wr = new DataOutputStream(conn.getOutputStream());
        wr.writeBytes("start=" + lexeme);
        if(!tags.equals("")){
            wr.writeBytes("&tags=" + tags);
        }
        if(GlobalMethods.lexemeIsWord){
            wr.writeBytes("&type=word");
        }else{
            wr.writeBytes("&type=sentence");
        }
        wr.flush();
        wr.close();
    }

    @Override
    protected String doInBackground(String... urls) {
        if(urls.length < 4){
            return "bad start sentence";
        }
        lexeme = urls[2];
        tags = urls[3];
        return super.doInBackground(urls);
    }
}