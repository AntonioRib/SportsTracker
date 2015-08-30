
// This is the Javascript file for the home views

$(document).ready(function() {
    $(loadActivities);

    $(function() {
        $('#filter-activities').keyup(loadActivities);
    });

    function loadActivities() {
        $('#activityList').html("");
        $.getJSON('activities.json',
            { search: $('#filter-activities').val() },
            function (data) {
                for( d in data ) {
                    if(data[d].owner_id == 1)
                    createLIActivity(data[d].id, data[d].name, data[d].duration, data[d].date,  data[d].place_id,  data[d].sport_id,  data[d].owner_id);
                }
            });
    }

    function createLIActivity(id, name, duration, date, place_id, sport_id, owner_id) {
        var code = [];
        code.push($('<div>').text("id:"+ id));
        code.push($('<div>').text("name:"+name));
        code.push($('<div>').text("dur:"+duration));
        code.push($('<div>').text("pid:"+place_id));
        code.push($('<div>').text("sid:"+sport_id));

        $('<li>').html(code).appendTo('#activityList');
    }
});


//TODO ESTE








