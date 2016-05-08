package sentencecraft.sentencecraft;

import android.content.Context;
import android.os.Handler;
import android.os.Message;
import android.support.design.widget.Snackbar;
import android.support.v4.content.ContextCompat;
import android.view.View;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by zqiu on 4/26/16.
 * extends DownloadInfoTask to get view sentences
 * Overrides onPostExecute to change how what the task does with the result of the page
 */
public class ViewSentenceTask extends DownloadInfoTask{

    private ArrayList<String> myTags;
    private Handler mainUIHandler;
    private View.OnClickListener listener;
    private int editId;

    //constructor. Also sets the call back Handler and a OnClickListener for each of the completed sentences
    public ViewSentenceTask(View rootView, Context context, int editId,Handler mainUIHandler, View.OnClickListener listener){
        super(rootView,context);
        this.mainUIHandler = mainUIHandler;
        this.listener = listener;
        this.editId = editId;
        myTags = new ArrayList<>();
    }

    /** onPostExecute displays the results of the AsyncTask. */
    @Override
    protected void onPostExecute(String result) {
        ArrayList<String> data = interpretView(result);
        TableLayout tl=(TableLayout)rootView.findViewById(editId);
        if(tl == null){
            return;
        }
        //remove rows in existing table
        tl.removeAllViews();
        for(int i = 0; i < data.size(); ++i){
            TableRow row = new TableRow(context);
            TableRow.LayoutParams lp = new TableRow.LayoutParams(TableRow.LayoutParams.WRAP_CONTENT);
            row.setLayoutParams(lp);
            TextView text= new TextView(context);
            text.setText(context.getString(R.string.view_sentence_part,i+1,data.get(i)));
            text.setPadding(0, 0, 0, (int) rootView.getResources().getDimension(R.dimen.activity_vertical_margin));
            text.setTextColor(ContextCompat.getColor(context, R.color.colorBlack));
            //makes the text clickable with the listener function
            text.setOnClickListener(listener);
            row.addView(text);
            tl.addView(row,i);
        }
        //send tags back to ViewSentence
        Message msg = Message.obtain();
        msg.obj= myTags;
        mainUIHandler.sendMessage(msg);
        //if there was an error let user know
        if(getResponseCode() != 200){
            Snackbar mySnackBar = Snackbar.make(rootView,result, Snackbar.LENGTH_LONG);
            mySnackBar.show();
        }
    }

    /** interprets what's read from view-sentences */
    private ArrayList<String> interpretView(String data){
        ArrayList<String> toReturn = new ArrayList<>();
        String temp;
        try{
            JSONArray reader= new JSONArray(data);
            for(int i = 0; i < reader.length(); ++i){
                JSONObject firstSentence = reader.getJSONObject(i);
                //gets lexemes and adds them together
                JSONArray lexemes = firstSentence.getJSONArray("lexemes");
                temp = "";
                for(int j = 0; j < lexemes.length(); ++j){
                    temp  += lexemes.getString(j) + " ";
                }
                toReturn.add(temp);
                temp = "";
                try{
                    //gets tags and also adds them together
                    JSONArray tags = firstSentence.getJSONArray("tags");
                    for(int j = 0; j < tags.length(); ++j){
                        if(j != 0){
                            temp += ",";
                        }
                        temp += tags.getString(j);
                    }
                }catch (JSONException e){
                    //e.printStackTrace();
                }
                myTags.add(temp);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        //if there were no completed sentences
        if(toReturn.size() == 0){
            toReturn.add(data);
            myTags.add("None");
        }
        return toReturn;
    }
}
