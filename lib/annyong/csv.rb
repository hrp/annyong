#
# Handler for text/csv
#
require 'csv'

module Annyong

  class CSV
    CSV_PAGE = <<-PAGE
<!doctype html>
<html><head>
  <title>%s</title>
  <meta http-equiv="content-type" content="text/html; charset=utf-8" />
  <style type="text/css">
  #{File.read(File.join(File.dirname(__FILE__), "../../assets/css/annyong.css")).gsub(/%/, "%%")}
  </style>
  <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js"></script>
  <script type="text/javascript" src="http://www.datatables.net/release-datatables/media/js/jquery.dataTables.js"></script>
  <script type="text/javascript">
    $(document).ready(function() { $('#data').dataTable({"bLengthChange": false, "bFilter": false, "bInfo": false, "bPaginate":false}); } );
  </script>
</head><body> 
<h1>%s</h1>
<table id="data">
  <thead>
    <tr>
    %s
    </tr>
  </thead>
  <tbody>
%s
  </tbody>
</table>
<footer><code>csv mode</code>, <a target='_blank' title='Powered by annyong' href='https://github.com/remiprev/annyong'>annyong</a>!</footer></body
</body></html>
    PAGE
    TOP = "<th>%s</th>"
    ROW = "<tr>%s</tr>\n"
    CELL = "<td>%s</td>"

    def initialize(root, path, col_sep = ',')
      @root, @path = root, path
      @col_sep = col_sep
    end

    def body#(env)
      file = ::CSV.read(@path, :col_sep => @col_sep)
      show_path = @path.gsub(/#{@root}/,'')
      #  num_cols = file.max{|a,b| a.count <=> b.count}.count
      num_cols = file.first.count
      num_rows = file.count
      top = (1..num_cols).map{|h| TOP % ("Column " + h.to_s)}.reduce(:<<)
      rows = file.map do |r|
        ROW % (r.map{|c| CELL % c}.join)
      end.join
      CSV_PAGE % [ show_path, show_path, top, rows, show_path ]
    end

  end
end
