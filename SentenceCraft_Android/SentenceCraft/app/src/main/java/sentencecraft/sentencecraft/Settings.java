package sentencecraft.sentencecraft;

import android.os.Bundle;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.widget.CompoundButton;
import android.widget.Switch;

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

        //set switch and listener for network switch
        Switch networkSwitch = (Switch) findViewById(R.id.networkSwitch);
        if(networkSwitch != null){
            networkSwitch.setChecked(GlobalValues.networkIsLocalhost);
            networkSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
                @Override
                public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                    GlobalValues.networkIsLocalhost = isChecked;
                }
            });
        }

        //set switch and listener for lexeme switch
        Switch lexemeSwitch = (Switch) findViewById(R.id.lexemeswitch);
        if(lexemeSwitch != null){
            lexemeSwitch.setChecked(GlobalValues.lexemeIsWord);
            lexemeSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
                @Override
                public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                    GlobalValues.lexemeIsWord = isChecked;
                }
            });
        }
    }
}
