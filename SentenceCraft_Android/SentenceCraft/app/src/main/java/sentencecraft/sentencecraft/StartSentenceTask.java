package sentencecraft.sentencecraft;

import android.content.Context;
import android.support.design.widget.Snackbar;
import android.view.View;

import java.io.DataOutputStream;
import java.io.IOException;
import java.net.HttpURLConnection;

/**
 * Created by zqiu on 4/27/16.
 * Used to asynchronously start sentences for StartSentence
 */
public class StartSentenceTask extends DownloadInfoTask {

    private String lexeme;
    private String tags;

    /** default constructor */
    public StartSentenceTask(View rootView, Context context, int editId) {
        super(rootView, context, editId);
    }

    /** onPostExecute displays the results of the AsyncTask. */
    @Override
    protected void onPostExecute(String result) {
        String operationName = "start";
        Snackbar mySnackBar;
        if(getResponseCode() == 200){
            mySnackBar = Snackbar.make(rootView,context.getString(R.string.success_operation,operationName),
                    Snackbar.LENGTH_SHORT);
            mySnackBar.show();
        }else{
            //error code. Let user know
            mySnackBar = Snackbar.make(rootView,context.getString(R.string.error_operation_not_complete,operationName),
                    Snackbar.LENGTH_LONG);
            mySnackBar.show();
            mySnackBar.setText(result);
            mySnackBar.show();
        }
    }

    @Override
    protected void sendAdditionalData(HttpURLConnection conn) throws IOException {
        //send additional form data
        DataOutputStream wr = new DataOutputStream(conn.getOutputStream());
        wr.writeBytes("start=" + lexeme);
        if(!tags.equals("")){
            wr.writeBytes("&tags=" + tags);
        }
        wr.writeBytes("&"+ GlobalValues.getTypeExtension());
        wr.flush();
        wr.close();
    }

    @Override
    protected String doInBackground(String... urls) {
        //error check
        if(urls.length != 4){
            return "bad start sentence";
        }
        lexeme = urls[2];
        tags = urls[3];
        return super.doInBackground(urls);
    }
}