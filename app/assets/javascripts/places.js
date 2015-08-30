
$(document).ready(function() {
    loadPlaces();
});
    $(function() {
        $('#filter-places').keyup(loadPlaces);
    });

    function loadPlaces() {
        $('#placesList').html("");
        $.getJSON('places.json',
            { filter: $('#filter-places').val() },
            function (data) {
                for( d in data ) {
                    if(data[d].name.toLowerCase().indexOf($('#filter-places').val().toLowerCase()) >= 0) {
                        createLIActivity(data[d].id, data[d].name);
                    }
                }
            });
    }

    function createLIActivity(id, name) {
        var code = [];
        code.push($("<a href=/places/"+id+">").text(name));
        $("<li class=list-group-item>").html(code).appendTo('#placesList');
    }

