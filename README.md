# londonCycles

Demo, illustrating XMLParser gathering of Transport For London XML feed, pertaining to the London Cycle
hire scheme, and mapping of that data to an MKMapView (includes basic routing).

XML structure can be viewed in a web browser, at:

http://www.tfl.gov.uk/tfl/syndication/feeds/cycle-hire/livecyclehireupdates.xml

This demo parses the XML feed, and populates an MKMapView with custom annotations, which are
filtered by zoom level (arbitrary, and changed by altering scale factors in defines, below.

Tapping an annotation pops up a callout which displays data from feed, i.e. name of station,
and empty/available docks.

Basic routing overlay, also.
