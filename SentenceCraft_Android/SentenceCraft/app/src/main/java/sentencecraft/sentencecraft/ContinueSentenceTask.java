package sentencecraft.sentencecraft;

import android.content.Context;
import android.support.design.widget.Snackbar;
import android.view.View;
import android.widget.TextView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.DataOutputStream;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.util.ArrayList;

/**
 * Created by zqiu on 4/27/16.
 */
public class ContinueSentenceTask extends DownloadInfoTask {

    private int tagsId;
    private String key = "";
    private String operationName = "DownloadTask";
    private String lexemeToAdd = "";
    private String isComplete = "";

    public ContinueSentenceTask(View rootView, Context context, int editId, int tagsId) {
        super(rootView, context, editId);
        this.tagsId = tagsId;
    }

    protected void onPostExecute(String result) {
        if (key.equals("")) {
            if (getResponseCode() == 200) {
                ArrayList<String> data = interpretContinue(result);
                TextView sentence = (TextView) rootView.findViewById(editId);
                sentence.setText(context.getString(R.string.continue_lexeme_part, data.get(0)));
                TextView tags = (TextView) rootView.findViewById(tagsId);
                tags.setText(context.getString(R.string.continue_tags_part, data.get(1)));
            } else {
                Snackbar mySnackBar;
                mySnackBar = Snackbar.make(rootView, context.getString(R.string.error_operation_not_complete, operationName), Snackbar.LENGTH_LONG);
                mySnackBar.show();
                mySnackBar.setText(result);
                mySnackBar.show();
            }
        }
    }

    private ArrayList<String> interpretContinue(String data) {
        ArrayList<String> toReturn = new ArrayList<>();
        String userdata = "";
        String tagdata = "";
        try {
            JSONObject reader = new JSONObject(data);
            key = reader.getString("key");
            JSONObject lexemeCollection = reader.getJSONObject("lexemecollection");
            JSONArray lexemes = lexemeCollection.getJSONArray("lexemes");
            for (int i = 0; i < lexemes.length(); ++i) {
                userdata += lexemes.getString(i) + " ";
            }
            try {
                JSONArray tags = lexemeCollection.getJSONArray("tags");
                for (int i = 0; i < tags.length(); ++i) {
                    if (!tagdata.equals("")) {
                        tagdata += ",";
                    }
                    tagdata += tags.getString(i);
                }
            } catch (JSONException e) {
                tagdata = "none";
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        toReturn.add(userdata);
        toReturn.add(tagdata);
        return toReturn;
    }

    @Override
    protected String doInBackground(String... urls) {
        if(urls.length == 2){
            //assuming getting incomplete sentence
            key = "";
            return super.doInBackground(urls);
        }else if(urls.length == 4){
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