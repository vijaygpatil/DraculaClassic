using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Calendar;

class DraculaView extends Ui.View {

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
    	View.onUpdate(dc);
    	
    	var width = dc.getWidth();
        var height = dc.getHeight();
        var clockTime = Sys.getClockTime();
        var hh, hour;
        var m, min;

        var now = Time.now();
        var info = Calendar.info(now, Time.FORMAT_LONG);
        
        hh = info.hour;
	    m = info.min;
	    var dd = "AM";
	    var h = hh;
	    
	    if (h >= 12) {
	        h = hh-12;
	        dd = "PM";
	    }
	    
	    if (h == 0) {
	        h = 12;
	    }
	    m = m<10?"0"+m:m;
	    h = h<10?"0"+h:h;
	    
	    var timeStr = Lang.format("$1$:$2$ $3$", [h, m, dd]);
		dc.drawText(width/2, (3*height/4 - 18), Gfx.FONT_TINY, timeStr, Gfx.TEXT_JUSTIFY_CENTER);
        var dateStr = Lang.format("$1$ $2$ $3$", [info.day_of_week, info.month, info.day]);
        dc.drawText(width/2,(3*height/4),Gfx.FONT_TINY, dateStr, Gfx.TEXT_JUSTIFY_CENTER);

        dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_TRANSPARENT);

        hour = ( ( ( clockTime.hour % 12 ) * 60 ) + clockTime.min );
        hour = hour / (12 * 60.0);
        hour = hour * Math.PI * 2;
        drawHand(dc, hour, 60, 5);
        
        hour = ( ( ( clockTime.hour+6 % 12 ) * 60 ) + clockTime.min );
        hour = hour / (12 * 60.0);
        hour = hour * Math.PI * 2;
        drawHand(dc, hour, 15, 5);
        
        min = ( clockTime.min / 60.0) * Math.PI * 2;
        drawHand(dc, min, 100, 5);
        min = ( (clockTime.min + 30) / 60.0) * Math.PI * 2;
        drawHand(dc, min, 15, 5);
        
        dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_BLACK);
        dc.fillCircle(width/2, height/2, 7);
        dc.setColor(Gfx.COLOR_BLACK,Gfx.COLOR_BLACK);
        dc.drawCircle(width/2, height/2, 7);
    }
    
    function drawHand(dc, angle, length, width) {
        var coords = [ [-(width/2),0], [-(width/2), -length], [width/2, -length], [width/2, 0] ];
        var result = new [4];
        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;
        var cos = Math.cos(angle);
        var sin = Math.sin(angle);

        for (var i = 0; i < 4; i += 1)
        {
            var x = (coords[i][0] * cos) - (coords[i][1] * sin);
            var y = (coords[i][0] * sin) + (coords[i][1] * cos);
            result[i] = [ centerX+x, centerY+y];
        }

        dc.fillPolygon(result);
        dc.fillPolygon(result);
    }
    
    function onExitSleep() {
    }
    
    function onEnterSleep() {
    }

}