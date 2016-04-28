package sentencecraft.sentencecraft;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.TextView;

public class MoreSentenceInfo extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_more_sentence_info);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        // Get a support ActionBar corresponding to this toolbar
        ActionBar ab = getSupportActionBar();

        // Enable the Up button
        if(ab != null){
            ab.setDisplayHomeAsUpEnabled(true);
        }

        //receive extras passed to this intent. Edit associated TextViews appropriately
        Bundle extras = getIntent().getExtras();
        if (extras != null) {
            String value = extras.getString("LEXEMES");
            TextView textLexeme = (TextView) findViewById(R.id.more_info_lexeme);
            if(textLexeme != null && value != null){
                //don't display the index of the lexeme
                textLexeme.setText(value.substring(2));
            }
            value = extras.getString("TAGS");
            TextView textTags = (TextView) findViewById(R.id.more_info_tag);
            if(textTags != null && value != null){
                if(value.equals("")){
                    value = "none";
                }
                textTags.setText(getString(R.string.continue_tags_part,value));
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
}
