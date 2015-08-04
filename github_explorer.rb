require 'github_api'

class GithubExplorer

  def execute_game
    display_intro
    puts "Please enter a Github Username, or enter Exit to quit."
    query = gets.chomp.downcase
    if query == "exit"
      display_credits
      return
    else
      display_loading_animation
      retrieve_github_information(query)
      display_credits
    end
  end

  private

  def retrieve_github_information(query)
    l = []
    # try to rescue all exceptions here.
    begin
      # normally I would use dotenv gem here to store the keys below
      github = Github.new client_id: '17a5794a8a7e2916f0fb', client_secret: '91aeef83e0b9e98f80a63fd4fe69662b7e939893'
      response = github.repos.list user: "#{query}"
      response.each do |repo|
        l << repo.language
      end
    rescue
      puts "There seems to be a problem. You may have entered an invalid character, or that user may not exist. Please try again."
    else
      puts "Github user #{query}'s favorite programming languages are:"
      # I needed to sort the array below by item frequency, then alphebetically. I got this fancy method below from stackoverflow, but it works.
      solution = l.each_with_object(Hash.new(0)){ |m,h| h[m] += 1 }.sort_by{ |k,v| v }
      if solution == nil
        puts "This user has no valid github account. Please try again."
        return
      else
        solution.reverse.each do |language, frequency|
          next if language == nil
          puts "#{language}: Seen #{frequency} times."
        end
      end  
    end
  end 

  def initialize
    system "clear"
    @text = <<-test
                                     
                                     ██████╗ ██╗████████╗██╗  ██╗██╗   ██╗██████╗ 
                                    ██╔════╝ ██║╚══██╔══╝██║  ██║██║   ██║██╔══██╗
                                    ██║  ███╗██║   ██║   ███████║██║   ██║██████╔╝
                                    ██║   ██║██║   ██║   ██╔══██║██║   ██║██╔══██╗
                                    ╚██████╔╝██║   ██║   ██║  ██║╚██████╔╝██████╔╝
                                     ╚═════╝ ╚═╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═════╝
                             

                 Github Repo Favorite Language Explorer 1.0 - This software is best viewed in a wide format.


   test
   puts "\n"
  end

  def display_intro
    puts @text
  end

  def display_credits
    puts "-----------------------------------------------------"
    puts "Thank you for using the Github Repo Favorite Language Explorer. If you have any questions or comments whatsoever, please email Hi@JesseWaites.com"
    puts "Note: Due to the github_api gem using version 0.8 instead of version 0.9 of Faraday, we cannot currently suppress the 'Faraday::Builder is now Faraday::RackBuilder' message at this time."
    puts "Source: https://github.com/thrasr/GitHub-Email-Scraper/issues/1"
  end

  def display_loading_animation
    progress = 'Calculating: '
    1000.times do |i|
     
    # i is number from 0-999
    j = i + 1
     
      # add 1 percent every 10 times
      if j % 10 == 0
        progress << "="
        # move the cursor to the beginning of the line with \r
        print "\r"
        # puts add \n to the end of string, use print instead
        print progress + " #{j / 10} %"
     
        # force the output to appear immediately when using print
        # by default when \n is printed to the standard output, the buffer is flushed.
        $stdout.flush
        sleep 0.05
      end
    end
    print "\r"
  end

  explorer = GithubExplorer.new
  explorer.execute_game

end
