package sentencecraft.sentencecraft;

import android.content.Context;
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

public class ContinueSentence extends AppCompatActivity {
    String key = "";
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_continue_sentence);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        // Get a support ActionBar corresponding to this toolbar
        ActionBar ab = getSupportActionBar();

        // Enable the Up button
        if(ab != null){
            ab.setDisplayHomeAsUpEnabled(true);
        }

        View myView = findViewById(android.R.id.content);
        String stringUrl = GlobalMethods.getBaseURL()+GlobalMethods.getContinueSentenceRequest()+"?"+GlobalMethods.getTypeExtension();
        ConnectivityManager connMgr = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo networkInfo = connMgr.getActiveNetworkInfo();
        if (networkInfo != null && networkInfo.isConnected()) {
            Handler asyncHandler = new Handler(){
                public void handleMessage(Message msg){
                    super.handleMessage(msg);
                    key = msg.obj.toString();
                }
            };
            ContinueSentenceTask task = new ContinueSentenceTask(myView, getApplicationContext(), R.id.continue_sentence, R.id.continue_tag,asyncHandler);
            task.execute("GET",stringUrl);
        } else {
            if(myView != null){
                Snackbar mySnackBar = Snackbar.make(myView, R.string.error_no_internet, Snackbar.LENGTH_SHORT);
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
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    public void continueRespondToBtn(View view){
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

        View myView = findViewById(android.R.id.content);
        String stringUrl = GlobalMethods.getBaseURL()+GlobalMethods.getContinueSentencePost();
        ConnectivityManager connMgr = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo networkInfo = connMgr.getActiveNetworkInfo();
        if (networkInfo != null && networkInfo.isConnected()) {
            ResolveSentenceTask task = new ResolveSentenceTask(myView, getApplicationContext(), R.id.continue_sentence, key);
            switch(view.getId()){
                case R.id.continue_btn:
                    task.execute("POST",stringUrl,sLexeme,"false");
                    break;
                case R.id.finish_btn:
                    task.execute("POST",stringUrl,sLexeme,"true");
                    break;
                default:
                    Log.d(getString(R.string.app_name),"button pressed did not have associated id.");
                    return;
            }
        } else {
            if(myView != null){
                Snackbar mySnackBar = Snackbar.make(myView, R.string.error_no_internet, Snackbar.LENGTH_SHORT);
                mySnackBar.show();
            }
        }
    }
}

