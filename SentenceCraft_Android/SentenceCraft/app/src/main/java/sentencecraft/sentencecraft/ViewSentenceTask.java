package sentencecraft.sentencecraft;

import android.content.Context;
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
 */
public class ViewSentenceTask extends DownloadInfoTask{

    public ViewSentenceTask(View rootView, Context context, int editId){
        super(rootView,context,editId);
    }

    // onPostExecute displays the results of the AsyncTask.
    @Override
    protected void onPostExecute(String result) {
        ArrayList<String> data = interpretView(result);
        TableLayout tl=(TableLayout)rootView.findViewById(editId);
        //remove rows in existing table
        tl.removeAllViews();
        for(int i = 0; i < data.size(); ++i){
            TableRow row = new TableRow(context);
            TableRow.LayoutParams lp = new TableRow.LayoutParams(TableRow.LayoutParams.WRAP_CONTENT);
            row.setLayoutParams(lp);
            TextView text= new TextView(context);
            text.setText(context.getString(R.string.view_sentence_part,i,data.get(i)));
            text.setPadding(0, 0, 0, (int) rootView.getResources().getDimension(R.dimen.activity_vertical_margin));
            text.setTextColor((int) ContextCompat.getColor(context, R.color.colorBlack));
            row.addView(text);
            tl.addView(row,i);
        }
    }

    //interprets what's read from view-sentences
    private ArrayList<String> interpretView(String data){
        ArrayList<String> toReturn = new ArrayList<>();
        String temp = "";
        try{
            JSONArray reader= new JSONArray(data);
            for(int i = 0; i < reader.length(); ++i){
                JSONObject firstSentence = reader.getJSONObject(i);
                JSONArray lexemes = firstSentence.getJSONArray("lexemes");
                temp = "";
                for(int j = 0; j < lexemes.length(); ++j){
                    temp  += lexemes.getString(j) + " ";
                }
                toReturn.add(temp);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        if(toReturn.size() == 0){
            toReturn.add(data);
        }
        return toReturn;
    }
}
