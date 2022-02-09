module Serialization
  def save
    file_name = 'save.json'
    File.open(file_name, 'w') { |file| file.write(save_to_json) }
  end

  def save_to_json
    JSON.dump({
      :correct_letters => @correct_letters,
      :word => @word,
      :tries => @tries
    })
  end

  def load
    save_file = File.read('save.json')
    json_data = JSON.parse(save_file)

    @correct_letters = json_data['correct_letters']
    @word = json_data['word']
    @tries = json_data['tries']
  end
end
