#
# Handler for text/csv
#
require 'csv'

module Annyong

  class TSV
    PAGE = <<-PAGE
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
    $(document).ready(function() { $('#table').dataTable(); } );
  </script>
</head><body> 
<h1>%s</h1>
<table id="table">
  <tr>
  %s
  </tr>
%s
</table>
<footer><code>tsv mode</code>, <a target='_blank' title='Powered by annyong' href='https://github.com/remiprev/annyong'>annyong</a>!</footer></body
</body></html>
    PAGE
    TOP = "<th class=''>%s</th>"
    ROW = "<tr class=''>%s</tr>\n"
    CELL = "<td>%s</td>"

    def initialize(root, path)
      @root, @path = root, path
    end

    def body#(env)
      file = ::CSV.read(@path, :col_sep => "\t")
      show_path = @path.gsub(/#{@root}/,'')
      num_cols = file.max{|a,b| a.count <=> b.count}.count
      num_rows = file.count
      top = (1..num_cols).map{|h| TOP % h}.reduce(:<<)
      rows = file.map do |r|
        ROW % (r.map{|c| CELL % c}.join)
      end.join
      PAGE % [ show_path, show_path, top, rows, show_path ]
    end

  end
end
