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
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.TableLayout;
import android.widget.TextView;

import java.util.ArrayList;

public class ViewSentence extends AppCompatActivity {

    private ArrayList<String> myTags;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_view_sentence);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        // Get a support ActionBar corresponding to this toolbar
        ActionBar ab = getSupportActionBar();

        // Enable the Up button
        if(ab != null){
            ab.setDisplayHomeAsUpEnabled(true);
        }

        //call updateText to fill table with completed sentences
        updateText(findViewById(R.id.test));
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

    public void updateText(View view){
        String stringUrl = GlobalValues.getBaseURL()+ GlobalValues.getViewExtension()+"?"+ GlobalValues.getTypeExtension();
        EditText viewTags = (EditText)findViewById(R.id.viewSearchTags);
        String tags = "";

        //get tags and submit as part of the URL
        if(viewTags != null){
            tags = viewTags.getText().toString();
        }
        if(!tags.equals("")){
            stringUrl += "&tags=" + tags;
        }

        //call ViewSentenceTask and set up a Handler to set myTags upon async task completion
        ConnectivityManager connMgr = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo networkInfo = connMgr.getActiveNetworkInfo();
        if (networkInfo != null && networkInfo.isConnected()) {
            Handler asyncHandler = new Handler(){
                public void handleMessage(Message msg){
                    super.handleMessage(msg);
                    myTags = (ArrayList<String>)msg.obj;
                }
            };
            ViewSentenceTask task = new ViewSentenceTask(view,getApplicationContext(),R.id.toedit,asyncHandler, new myListener());
            task.execute("GET", stringUrl);
        } else {
            TableLayout tl = (TableLayout)findViewById(R.id.toedit);
            //remove rows in existing table
            if(tl != null){
                tl.removeAllViews();
            }
            Snackbar mySnackBar = Snackbar.make(view, R.string.error_no_internet, Snackbar.LENGTH_SHORT);
            mySnackBar.show();
        }
    }

    //listener class to respond to clicks on the completed sentences
    public class myListener implements View.OnClickListener{
        @Override
        public void onClick(View v) {
            TextView selected = (TextView)v;
            if(selected != null){
                //get associated lexeme and tag
                String data = selected.getText().toString();
                String sTag = myTags.get((data.charAt(0) - '0'));
                //create MoreSentenceInfo intent and pack with above data
                Intent intent = new Intent(getBaseContext(), MoreSentenceInfo.class);
                intent.putExtra("LEXEMES", data);
                intent.putExtra("TAGS",sTag);
                startActivity(intent);
            }
        }
    }
}
