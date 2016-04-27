// Setup the angular module with our application
var app = angular.module('sentence_craft_app', []);

// Jinja and Angular Templates conflict with each other
// This allows for the use of {[<field>]} to resolve this conflict
app.config(['$interpolateProvider', function($interpolateProvider) {
     $interpolateProvider.startSymbol('{[');
          $interpolateProvider.endSymbol(']}');
}]);

// Initialze the Data service used for making API Calls
app.service('dataService', function($http){    
    // View Sentences
    // Pass a POST request containing the tag list (a comma separated string)
    // Sentences that are returned will contain all tags in the list
    this.viewSentence = function(tag_list){
        return $http({
                url: '/view-sentences/',
                method: "POST",
                data: $.param({ tags: tag_list}),
                headers : { 'Content-Type' : 'application/x-www-form-urlencoded' }
        });
    }
    // Incomplete Sentence
    // Pass a GET request to checkout an incomplete sentence 
    // for completion 
    this.incompleteSentence = function(){
        return $http({
                url: '/incomplete-sentence/',
                method: "GET",
        });
    }

    // Start Sentence
    // Pass a POST request containing the string starting_text  
    // along with a comma separated string of tags  
    this.startSentence = function(start_text, tag_list){
        return $http({
                url: '/start-sentence/',
                method: "POST",
                data: $.param({ sentence_start: start_text, tags: tag_list }),
                headers : { 'Content-Type' : 'application/x-www-form-urlencoded' }
        });
    }

    // Continue Sentence
    // Pass a POST request containing a string of the continuing text,
    // a string containing the key of the checked out setence,
    // and a boolean complete_flag.
    //
    // complete_flag is true when lexemes are completed and false when
    // they are continued.
    this.continueSentence = function(continue_text, key_val, complete_flag){
       return $http({
                url: '/complete-sentence/',
                method: "POST",
                data: $.param({ sentence_addition: continue_text, key: key_val, complete: complete_flag}),
                headers : { 'Content-Type' : 'application/x-www-form-urlencoded' }
        });
    } 
});

// The view control is responsible for handling the main functionality
// of the web application. The controller provides dynamic operations. 
app.controller('view_controller', function ($scope,$http,$window, dataService) {
    // Shared node_js data model
    $scope.model = {
        sentence_start_text: '',
        sentence_continue_text: '',
        tag_list: [],
        incomplete_sentence: '',
        previous_lexeme: ''
    };

    // Remove a single tag from the list of dynamically generated tags
    // if any are present
    $scope.remove_tag = function () {
        if ($scope.model.tag_list.length > 0){
            $scope.model.tag_list.pop();
            $(".add-tag").show();
        }
        if($scope.model.tag_list.length === 0){
            $(".remove-tag").hide();
        }
    };

    // Add a tag to the list of dynamically generated tags 
    $scope.add_tag = function () {
        // initialze if no tags already exist
        if ($scope.model.tag_list.length == 0){
            $scope.model.tag_list = [''];
            $(".remove-tag").show();
        }                        
        else {
            // Require that the tag fields contain text
            if ($scope.model.tag_list[($scope.model.tag_list.length-1)] == '') {
                $window.alert("Please add the tag text!");
            }
            else if ($scope.model.tag_list.length < 5){
                $scope.model.tag_list.push('');
            } 
            else{
                $window.alert("Maximum number of tags reached");
                $("#entry").focus();
                $(".add-tag").hide();
            }            
        }
    };

    // Reset the displayed fields in the data model
    $scope.clear_fields = function(){
        $scope.model.sentence_start_text = '';
        $scope.model.sentence_continue_text = '';
        $scope.model.tag_list = [];
        $scope.model.previous_lexeme = '';
        $(".remove-tag").hide();
    }

    // Forward API continue sentence request to the data service
    $scope.continue_sentence_api_call = function(complete){
        var key = $scope.model.incomplete_sentence.key; 
        var addition = $scope.model.sentence_continue_text;
        dataService.continueSentence(addition, key, complete).then(function (dataResponse) {
            $scope.clear_fields();
            // Prompt the user to continue another lexeme
            $scope.operation_type = 'ContinueAnother';
        });
    }
    
    // Forward API incomplete sentence request to the data service
    $scope.view_continue_list_panel = function(){
       $scope.clear_fields();
       $scope.operation_type = 'ContinueSentence'; 
       dataService.incompleteSentence().then(function (dataResponse){
            //TODO replace this with the error code
            if (dataResponse.data == "ERROR: No incomplete sentences are available."){
                // Prompt the user that there are no more sentences to complete
                $scope.operation_type='NoneToComplete';
            }
            else{
                var to_complete = dataResponse.data;
                $scope.model.incomplete_sentence = to_complete;
                // Get the last 3 lexemes from the lexeme collection
                var to_complete_lexemes = to_complete.lexemecollection.lexemes;
                for(var i = to_complete_lexemes.length-3; i < to_complete_lexemes.length; ++i){
                    $scope.model.previous_lexeme += to_complete_lexemes[i] + ' ';
                }
            }
       });
    }

    // Prompt the user to start a new sentence
    $scope.view_start_new_sentence_panel = function () {
        $scope.clear_fields();
        $scope.operation_type = 'StartNewSentence';
        $(".remove-tag").hide();
    }

    // Display the 10 most recent sentences to the user
    // matching the tags list
    $scope.view_sentence_list_panel = function () {
        
        // Show the list of sentences to the user
        $scope.operation_type = 'ViewSentenceList';

        // Convert the tags to a string if they exist 
        var tagList = '';
        if ($scope.model.tag_list != undefined){
            tagList = $scope.model.tag_list.toString();
        }

        // Forward API view sentence request to the data service
        dataService.viewSentence(tagList).then(function (dataResponse) {
            var data2 = dataResponse.data;
            var rep = []; 
          
            if (data2.length === 0){
                $scope.view_data = 'NoneToView';
                return;
            }

            $scope.view_data = 'SomeToView';    

            // Generate the list of lexemes
            for (var i = 0; i < data2.length; ++i){
                var tmp = '';
                var lexemes = data2[i].lexemes; 
                for (var j=0; j < lexemes.length; ++j){
                    tmp = tmp + lexemes[j] + ' ';
                }
                rep.push(tmp);
            }
            $scope.data = rep;
        })
    };

    // Forward API start sentence behavior to the data service
    $scope.start_new_sentence_api_call = function () {                    
        
        // Generate a string representation of the tags list
        var tag_list = '';
        if ($scope.model.tag_list != undefined){
            tag_list = $scope.model.tag_list.toString();
        }
        var start_text = $scope.model.sentence_start_text; 

        // Forward the API request to the data service
        dataService.startSentence(start_text, tag_list).then(function (dataResponse) {
            $scope.clear_fields();
            if (dataResponse.status === 200){
                $scope.operation_type = 'SuccessfulComplete';
            }
            else{
                $scope.operation_type = 'FailedStart';
            }
        })
    }
});            
