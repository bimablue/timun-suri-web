require "rubygems"
require "cucumber"
require "cucumber/rake/task"
require "parallel_tests"
require "cuke_sniffer"
require "report_builder"

namespace :icebox do
  Cucumber::Rake::Task.new do |t|
    t.cucumber_opts = %w{--format progress}
  end

  Cucumber::Rake::Task.new(:test, "Run Ice Box Automation Test") do |t|
    # sample use: rake icebox:test t=@login REPORT_NAME=2
    t.cucumber_opts = ["-t #{ENV["t"]}"] unless ENV["t"].nil?
    t.cucumber_opts = ["features/#{ENV["f"]}"] unless ENV["f"].nil?
    t.profile = "rake_run"
  end

  desc "Parallel run"
  task :parallel do
    puts " ====== Parallel execution Start ========"
    abort "Failed to proceed, tags needed for parallel (t=@sometag)" if ENV["t"].nil?
    Rake::Task["icebox:clear_report"].execute
    Rake::Task["icebox:init_report"].execute

    begin
      system "bundle exec parallel_cucumber features/ -n 4 -o '-t #{ENV["t"]}'"
    rescue => exception
      p "Found error!"
      pp exception
    ensure
      p "======= After ========"
      p "merging report:"
      Rake::Task["icebox:merge_report"].execute
    end
  end

  task :clear_report do
    puts " ========Deleting old reports ang logs========="
    report_root = File.absolute_path("./report")
    FileUtils.rm_rf(report_root, secure: true)
    FileUtils.mkdir_p report_root
  end

  task :init_report do
    report_root = File.absolute_path("./report")
    ENV["REPORT_PATH"] = Time.now.strftime("%F_%H-%M-%S")
    p "about to create report #{ENV["REPORT_PATH"]}"
    FileUtils.mkdir_p "#{report_root}/#{ENV["REPORT_PATH"]}"
  end

  task :merge_report do
    # Merging all report found in the directory
    # sample usage `rake icebox:merge_report REPORT_PATH=2018-09-21_14-42-22`
    puts " =========:: Merging Report ::============="
    FileUtils.mkdir_p "report/output"
    options = {
      input_path: "report/#{ENV["REPORT_PATH"]}",
      report_path: "report/output/test_report_#{ENV["REPORT_PATH"]}",
      report_types: ["retry", "html", "json"],
      report_title: "icebox Report",
      color: "blue",
      additional_info: {"Browser" => "Chrome", "Environment" => ENV["BASE_URL"].to_s, "Generated report" => Time.now},
    }
    ReportBuilder.build_report options
  end

  task :run do
    # Before all
    Rake::Task["icebox:clear_report"].execute

    # Test 1
    Rake::Task["icebox:init_report"].execute
    system "rake icebox:test t=@login"

    # Test 2
    Rake::Task["icebox:init_report"].execute
    system "rake icebox:test t=@signup"

    # After all
    Rake::Task["icebox:merge_report"].execute
  end

  task :rerun do
    if File.size("report/#{ENV['REPORT_PATH']}/rerun.txt").zero?
      puts '=====:: Nice, All is well '
    else
      puts '=====:: Rerun Failed Scenarios '
      # Copy rerun to root, so it same level with features/
      puts "Original file: ./report/#{ENV['REPORT_PATH']}/rerun.txt"
      FileUtils.cp_r "./report/#{ENV['REPORT_PATH']}/rerun.txt", './rerun.txt'
      system "bundle exec cucumber @rerun.txt --format pretty --format html --out report/#{ENV['REPORT_PATH']}/features_report_rerun.html --format json --out=report/#{ENV['REPORT_PATH']}/cucumber_rerun.json -f rerun  -o report/#{ENV['REPORT_PATH']}/afterrerun.txt"
      if File.size("report/#{ENV['REPORT_PATH']}/afterrerun.txt").zero?
        @status = true
        puts '=====:: Nice, rerun makes all is well '
      else
        puts '=====:: Even after rerun, it still failed :('
      end
    end
  end

  task :police do
    sh "bundle exec cuke_sniffer --out html report/cuke_sniffer.html"
  end

  task :start_appium do
    puts "===== Installing Appium with NodeJS====="
    sh "npm install"
    sh " ./node_modules/.bin/appium > /dev/null 2>&1"
  end

  task parallel_run: %i[clear_report init_report parallel rerun merge_report]
end
