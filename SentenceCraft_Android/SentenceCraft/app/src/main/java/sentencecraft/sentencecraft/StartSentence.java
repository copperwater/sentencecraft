package sentencecraft.sentencecraft;

import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;

public class StartSentence extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_start_sentence);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        // Get a support ActionBar corresponding to this toolbar
        ActionBar ab = getSupportActionBar();

        // Enable the Up button
        if(ab != null){
            ab.setDisplayHomeAsUpEnabled(true);
        }

        TextView startDirections = (TextView) findViewById(R.id.start_directions);
        if(startDirections != null){
            startDirections.setText(getString(R.string.app_start_directions,GlobalMethods.getLexeme(),GlobalMethods.getLexemeCollection()));
        }

        EditText startLexeme = (EditText) findViewById(R.id.start_lexeme);
        if(startLexeme != null){
            startLexeme.setHint(GlobalMethods.getLexeme());
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

    public void addTag(View view) {
        Context context= getApplicationContext();
        TableLayout tl=(TableLayout)findViewById(R.id.start_to_edit);
        if(tl != null){
            TableRow row = new TableRow(context);
            TableRow.LayoutParams lp = new TableRow.LayoutParams(TableRow.LayoutParams.WRAP_CONTENT);
            row.setLayoutParams(lp);
            EditText text= new EditText(context);
            TableRow.LayoutParams textParams = new TableRow.LayoutParams(0, TableRow.LayoutParams.WRAP_CONTENT, 1f);
            text.setLayoutParams(textParams);
            text.setTextColor(ContextCompat.getColor(context, R.color.colorBlack));
            text.setHintTextColor(ContextCompat.getColor(context, R.color.colorBlack));
            text.setHint(getString(R.string.app_tag_hint));
            text.setPadding(0, 0, 0, (int) getResources().getDimension(R.dimen.activity_vertical_margin));
            row.addView(text);
            tl.addView(row,tl.getChildCount());
        }
    }

    public void sendStart(View view) {
        EditText mLexeme = (EditText) findViewById(R.id.start_lexeme);
        if (mLexeme == null) {
            Log.d(getString(R.string.app_name), "bad start_lexeme");
            return;
        }
        String sLexeme = mLexeme.getText().toString();
        Log.d(getString(R.string.app_name), sLexeme);
        if (sLexeme.equals("")) {
            Snackbar mySnackBar = Snackbar.make(view, R.string.error_no_lexeme, Snackbar.LENGTH_SHORT);
            mySnackBar.show();
            return;
        }
        TableLayout tl = (TableLayout) findViewById(R.id.start_to_edit);
        if (tl == null) {
            Log.d(getString(R.string.app_name), "no existing start_to_edit?");
            return;
        }
        String sTags = "";
        for (int i = 0; i < tl.getChildCount(); ++i) {
            TableRow row = (TableRow) tl.getChildAt(i);
            EditText mText = (EditText) row.getChildAt(0);
            String sText = mText.getText().toString();
            if (!sText.equals("")) {
                if (!sTags.equals("")) {
                    sTags += ",";
                }
                sTags += sText;
            }
        }
        Log.d(getString(R.string.app_name),"your tags:" + sTags);

        View myView = findViewById(android.R.id.content);
        String stringUrl = GlobalMethods.getBaseURL()+GlobalMethods.getStartSentenceExtension();
        ConnectivityManager connMgr = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo networkInfo = connMgr.getActiveNetworkInfo();
        if (networkInfo != null && networkInfo.isConnected()) {
            new StartSentenceTask(myView, getApplicationContext(), R.id.toedit).execute("POST", stringUrl, sLexeme, sTags);
        } else {
            Snackbar mySnackBar = Snackbar.make(view, R.string.error_no_internet, Snackbar.LENGTH_SHORT);
            mySnackBar.show();
        }
    }
}

