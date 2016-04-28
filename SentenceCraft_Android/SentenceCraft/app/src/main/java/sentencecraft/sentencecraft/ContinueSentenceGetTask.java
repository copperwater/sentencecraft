package sentencecraft.sentencecraft;

import android.content.Context;
import android.os.Handler;
import android.os.Message;
import android.support.design.widget.Snackbar;
import android.view.Gravity;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.TextView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by zqiu on 4/27/16
 * Used to asynchronously get incomplete sentences for the ContinueSentence Activity
 */

public class ContinueSentenceGetTask extends DownloadInfoTask {

    Handler mainUIHandler;
    private int tagsId;
    private String key = "";

    //constructor. Also sets internal handler and tagsId appropriately
    public ContinueSentenceGetTask(View rootView, Context context, int editId, int tagsId, Handler mainUIHandler) {
        super(rootView, context, editId);
        this.tagsId = tagsId;
        this.mainUIHandler = mainUIHandler;
    }

    //updates tagsId and editId with the appropriate result
    protected void onPostExecute(String result) {
        String operationName = "DownloadTask";
        if (getResponseCode() == 200) {
            ArrayList<String> data = interpretContinue(result);
            TextView sentence = (TextView) rootView.findViewById(editId);
            sentence.setText(context.getString(R.string.continue_lexeme_part, data.get(0)));
            TextView tags = (TextView) rootView.findViewById(tagsId);
            tags.setText(context.getString(R.string.continue_tags_part, data.get(1)));
        } else {
            //got bad response from server. Let user know
            Snackbar mySnackBar;
            mySnackBar = Snackbar.make(rootView, context.getString(R.string.error_operation_not_complete, operationName), Snackbar.LENGTH_LONG);
            View mView = mySnackBar.getView();
            FrameLayout.LayoutParams params =(FrameLayout.LayoutParams)mView.getLayoutParams();
            params.gravity = Gravity.TOP;
            mView.setLayoutParams(params);
            mySnackBar.show();
            mySnackBar.setText(result);
            mySnackBar.show();
        }
        //notify ContinueSentence and send it the key received from the server.
        Message msg = Message.obtain();
        msg.obj= key;
        mainUIHandler.sendMessage(msg);
    }

    //interprets JSON data received from the server
    private ArrayList<String> interpretContinue(String data) {
        ArrayList<String> toReturn = new ArrayList<>();
        String userData = "";
        String tagData = "";
        try {
            //gets key from JSON data
            JSONObject reader = new JSONObject(data);
            key = reader.getString("key");

            //gets lexemes and appends to userData
            JSONObject lexemeCollection = reader.getJSONObject("lexemecollection");
            JSONArray lexemes = lexemeCollection.getJSONArray("lexemes");
            for (int i = 0; i < lexemes.length(); ++i) {
                userData += lexemes.getString(i) + " ";
            }
            try {
                //get tag data and appends to tagData
                JSONArray tags = lexemeCollection.getJSONArray("tags");
                for (int i = 0; i < tags.length(); ++i) {
                    if (!tagData.equals("")) {
                        tagData += ",";
                    }
                    tagData += tags.getString(i);
                }
            } catch (JSONException e) {
                //set to none if there was not tags field in JSON data
                tagData = "none";
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        toReturn.add(userData);
        toReturn.add(tagData);
        return toReturn;
    }

    @Override
    protected String doInBackground(String... urls) {
        //error checking and then passing to parent class
        if(urls.length == 2){
            key = "";
            return super.doInBackground(urls);
        }else{
            return "arguments not recognized";
        }
    }
}
