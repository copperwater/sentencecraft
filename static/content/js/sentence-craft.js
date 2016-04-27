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
    // Pass a GET request to Checkout an incomplete sentence 
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
    $scope.model = {
        sentence_start_text: '',
        sentence_continue_text: '',
        tag_list: [],
        incomplete_sentence: ''
    };

    $scope.remove_tag = function () {
        if ($scope.model.tag_list.length > 0){
            $scope.model.tag_list.pop();
        }
    };

    $scope.add_tag = function () {
        if ($scope.model.tag_list.length == 0){
            $scope.model.tag_list = [''];
        }                        
        else {
            if ($scope.model.tag_list[($scope.model.tag_list.length-1)] == '') {
                $window.alert("Please add the tag text!");
            }
            else {
                $scope.model.tag_list.push('');
            }                        
        }
    };

    $scope.clear_fields = function(){
        $scope.model.sentence_start_text = '';
        $scope.model.sentence_continue_text = '';
        $scope.model.tag_list = [];
    }

    $scope.continue_sentence_api_call = function(complete){
        var key = $scope.model.incomplete_sentence.data.key; 
        var addition = $scope.model.sentence_continue_text;
        dataService.continueSentence(addition, key, complete).then(function (dataResponse) {
            $scope.clear_fields();
            $scope.operation_type = 'ContinueAnother';
        });
    }
    
    $scope.view_continue_list_panel = function(){
       $scope.clear_fields();
       $scope.operation_type = 'ContinueSentence'; 
       dataService.incompleteSentence().then(function (dataResponse){
            if (dataResponse.data == "ERROR: No incomplete sentences are available."){
                $scope.operation_type='NoneToComplete';
            }
            else{
                $scope.model.incomplete_sentence = dataResponse;
            }
       });
    }
    $scope.view_start_new_sentence_panel = function () {
        $scope.clear_fields();
        $scope.operation_type = 'StartNewSentence';
    }

    $scope.view_sentence_list_panel = function () {
        $scope.operation_type = 'ViewSentenceList';
        var tagList = '';
        if ($scope.model.tag_list != undefined){
            tagList = $scope.model.tag_list.toString();
        }

        dataService.viewSentence(tagList).then(function (dataResponse) {
            var data2 = dataResponse.data;
            var rep = []; 
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

    $scope.start_new_sentence_api_call = function () {                    
        var tag_list = '';
        if ($scope.model.tag_list != undefined){
            tag_list = $scope.model.tag_list.toString();
        }
        var start_text = $scope.model.sentence_start_text; 
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
