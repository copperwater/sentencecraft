package sentencecraft.sentencecraft;

import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.design.widget.Snackbar;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

public class ContinueSentence extends AppCompatActivity {

    String key = "";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_continue_sentence);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        View snackView = findViewById(R.id.continue_top);

        // Get a support ActionBar corresponding to this toolbar
        ActionBar ab = getSupportActionBar();

        // Enable the Up button
        if(ab != null){
            ab.setDisplayHomeAsUpEnabled(true);
        }

        //edit what's on the screen based off the lexeme received
        TextView continueDirections = (TextView)findViewById(R.id.continue_directions);
        if(continueDirections != null){
            continueDirections.setText(getString(R.string.app_continue_directions, GlobalValues.getLexeme(), GlobalValues.getLexemeCollection()));
        }
        EditText continueEditPrompt = (EditText)findViewById(R.id.continue_lexeme);
        if(continueEditPrompt != null){
            continueEditPrompt.setHint(GlobalValues.getLexeme());
        }

        //call ContinueSentenceGetTask and register it with a handler so that we receive a key upon completion
        String stringUrl = GlobalValues.getBaseURL()+ GlobalValues.getContinueSentenceRequest()+"?"+ GlobalValues.getTypeExtension();
        ConnectivityManager connMgr = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo networkInfo = connMgr.getActiveNetworkInfo();
        if (networkInfo != null && networkInfo.isConnected()) {
            Handler asyncHandler = new Handler(){
                public void handleMessage(Message msg){
                    super.handleMessage(msg);
                    key = msg.obj.toString();
                }
            };
            ContinueSentenceGetTask task = new ContinueSentenceGetTask(snackView, getApplicationContext(), R.id.continue_sentence, R.id.continue_tag,asyncHandler);
            task.execute("GET",stringUrl);
        } else {
            //notify user if no internet
            if(snackView != null){
                Snackbar mySnackBar = Snackbar.make(snackView, R.string.error_no_internet, Snackbar.LENGTH_SHORT);
                View mView = mySnackBar.getView();
                mySnackBar.show();
            }
        }
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

    public void continueRespondToBtn(View view){
        //error checking to see if lexeme was entered and if a key was received
        Log.d(getString(R.string.app_name),"key:"+key);
        EditText lexeme = (EditText) findViewById(R.id.continue_lexeme);
        if(lexeme == null){
            return;
        }
        String sLexeme = lexeme.getText().toString();
        if(sLexeme.equals("")){
            Snackbar mySnackBar = Snackbar.make(view, R.string.error_no_lexeme, Snackbar.LENGTH_SHORT);
            mySnackBar.show();
            return;
        }
        if(key.equals("")){
            Snackbar mySnackBar = Snackbar.make(view, getString(R.string.error_operation_not_complete,"get key"), Snackbar.LENGTH_SHORT);
            mySnackBar.show();
            return;
        }

        //call ContinueSentencePostTask with different arguments depending on the id of the button clicked
        String stringUrl = GlobalValues.getBaseURL()+ GlobalValues.getContinueSentencePost();
        ConnectivityManager connMgr = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo networkInfo = connMgr.getActiveNetworkInfo();
        if (networkInfo != null && networkInfo.isConnected()) {
            ContinueSentencePostTask task = new ContinueSentencePostTask(view, getApplicationContext(), R.id.continue_sentence, key);
            switch(view.getId()){
                case R.id.continue_btn:
                    task.execute("POST",stringUrl,sLexeme,"false");
                    break;
                case R.id.finish_btn:
                    task.execute("POST",stringUrl,sLexeme,"true");
                    break;
                default:
                    Log.d(getString(R.string.app_name),"button pressed did not have associated id.");
            }
        } else {
            if(view != null){
                //notify user if no internet
                Snackbar mySnackBar = Snackbar.make(view, R.string.error_no_internet, Snackbar.LENGTH_SHORT);
                mySnackBar.show();
            }
        }
    }
}
