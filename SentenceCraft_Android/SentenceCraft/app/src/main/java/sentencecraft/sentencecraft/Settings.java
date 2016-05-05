package sentencecraft.sentencecraft;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

public class Settings extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_settings);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        // Get a support ActionBar corresponding to this toolbar
        ActionBar ab = getSupportActionBar();

        // Enable the Up button
        if(ab != null){
            ab.setDisplayHomeAsUpEnabled(true);
        }

        //display current settings
        setNetworkAsLocalHost(GlobalValues.networkIsLocalhost);
        setWordAsLexeme(GlobalValues.lexemeIsWord);
    }

    /** respond to user clicks */
    public void settingButtonResponse(View view){
        boolean response = true;
        switch(view.getId()){
            case R.id.setting_remote:
                //use remote if that view was clicked
                response = false;
            case R.id.settings_localhost:
                GlobalValues.networkIsLocalhost = response;
                setNetworkAsLocalHost(response);
                break;
            case R.id.setting_sentence:
                //use sentences as the lexeme if it was clicked
                response = false;
            case R.id.setting_word:
                GlobalValues.lexemeIsWord = response;
                setWordAsLexeme(response);
                break;
            default:
                Log.d(getString(R.string.app_name),"Don't know how to respond to button click");
        }
    }

    /** deals with correctly coloring the right text view options for networking */
    private void setNetworkAsLocalHost(boolean response){
        Context context = getApplicationContext();
        TextView localhost = (TextView) findViewById(R.id.settings_localhost);
        TextView remote = (TextView) findViewById(R.id.setting_remote);
        if(localhost == null || remote == null){
            Log.d(getString(R.string.app_name),"could not find view");
            return;
        }
        if(response){
            localhost.setTextColor(ContextCompat.getColor(context, R.color.colorPrimary));
            remote.setTextColor(ContextCompat.getColor(context, R.color.colorBlack));
        }else{
            localhost.setTextColor(ContextCompat.getColor(context, R.color.colorBlack));
            remote.setTextColor(ContextCompat.getColor(context, R.color.colorPrimary));
        }
    }

    /** deals with correctly coloring the right text view options for lexemes */
    private void setWordAsLexeme(boolean response){
        Context context = getApplicationContext();
        TextView word = (TextView) findViewById(R.id.setting_word);
        TextView sentence = (TextView) findViewById(R.id.setting_sentence);
        if(word == null || sentence == null){
            Log.d(getString(R.string.app_name),"could not find view");
            return;
        }
        if(response){
            word.setTextColor(ContextCompat.getColor(context, R.color.colorPrimary));
            sentence.setTextColor(ContextCompat.getColor(context, R.color.colorBlack));
        }else{
            word.setTextColor(ContextCompat.getColor(context, R.color.colorBlack));
            sentence.setTextColor(ContextCompat.getColor(context, R.color.colorPrimary));
        }
    }
}
