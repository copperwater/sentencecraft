package sentencecraft.sentencecraft;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;

public class MainMenu extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_menu);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        dealWithOtherActivities();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main_menu, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        switch(item.getItemId()){
            case R.id.action_settings:
                Intent intent = new Intent(this, Settings.class);
                startActivity(intent);
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    /** called on button click. Will check for the button and create appropriate intent */
    public void buttonResponse(View view){
        Intent intent;
        switch(view.getId()){
            case R.id.main_start:
                intent = new Intent(this, StartSentence.class);
                break;
            case R.id.main_continue:
                intent = new Intent(this, ContinueSentence.class);
                break;
            case R.id.main_view:
                intent = new Intent(this, ViewSentence.class);
                break;
            default:
                Log.d(getString(R.string.app_name),"button pressed did not have associated id.");
                return;
        }
        startActivity(intent);
    }

    /** meant to deal with any extras passed to this intent */
    public void dealWithOtherActivities(){
        Bundle extras = getIntent().getExtras();
        if (extras != null) {
            String value = extras.getString("TASK");
            if(value == null){
                Log.d(getString(R.string.app_name),"No task to start");
                return;
            }
            View mainTop = findViewById(R.id.main_top);
            String stringUrl = extras.getString("URL");
            String sLexeme = extras.getString("LEXEME");
            switch(value){
                case "Continue":
                    String key = extras.getString("KEY");
                    String complete = extras.getString("COMPLETE");
                    if(key == null || stringUrl == null || sLexeme == null || complete == null){
                        Log.d(getString(R.string.app_name),"Invalid parameters");
                        return;
                    }
                    ContinueSentencePostTask task = new ContinueSentencePostTask(mainTop,
                            getApplicationContext(), key);
                    task.execute("POST",stringUrl,sLexeme,complete);
                    break;
                case "Start":
                    String sTags = extras.getString("TAGS");
                    if(stringUrl == null || sLexeme == null || sTags == null){
                        Log.d(getString(R.string.app_name),"Invalid parameters");
                        return;
                    }
                    new StartSentenceTask(mainTop, getApplicationContext()).
                            execute("POST", stringUrl, sLexeme, sTags);
                    break;
                default:
                    Log.d(getString(R.string.app_name),"Don't recognize task to start:"+value);
            }
        }
    }
}
