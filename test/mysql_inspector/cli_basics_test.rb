require 'helper'

describe "mysql-inspector -v" do

  subject { mysql_inspector "-v" }

  it "shows the version" do
    stderr.must_equal ""
    stdout.must_equal MysqlInspector::VERSION
    status.must_equal 0
  end
end

describe "mysql-inspector -h" do

  subject { mysql_inspector "-h" }

  it "shows the help" do
    stderr.must_equal ""
    stdout.must_equal <<-EOL.unindented
      Usage: mysql-inspector [options] command [command args]

      Options

              --out DIR                    Where to store schemas. Defaults to '.'
          -h, --help                       What you're looking at
          -v, --version                    Show the version of mysql-inspector

      Commands

        write DATABASE [VERSION]
        load DATABASE [VERSION]
        diff
        diff TO
        diff FROM TO
        grep PATTERN [PATTERN]

    EOL
    status.must_equal 0
  end
end

describe "mysql-inspector unknown_command" do

  subject { mysql_inspector "unknown_command" }

  it "fails" do
    stderr.must_equal "Unknown command \"unknown_command\""
    stdout.must_equal ""
    status.must_equal 1
  end
end
