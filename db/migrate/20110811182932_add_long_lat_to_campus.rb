class AddLongLatToCampus < ActiveRecord::Migration
  
  CAMPUS_COORDS = {
                    "1" => {"latitude" => 43.468889, "longitude" => -80.54},
                    "2" => {"latitude" => 43.008289, "longitude" => -81.271894},
                    "7" => {"latitude" => 53.524444, "longitude" => -113.524444},
                    "8" => {"latitude" => 51.0775, "longitude" => -114.133056},
                    "14" => {"latitude" => 49.276765, "longitude" => -122.917957},
                    "19" => {"latitude" => 49.266922, "longitude" => -123.247467},
                    "24" => {"latitude" => 49.809444, "longitude" => -97.132778},
                    "37" => {"latitude" => 44.636944, "longitude" => -63.591667},
                    "40" => {"latitude" => 44.631686, "longitude" => -63.579747},
                    "43" => {"latitude" => 45.3831, "longitude" => -75.6976},
                    "46" => {"latitude" => 43.263333, "longitude" => -79.918889},
                    "48" => {"latitude" => 44.224997, "longitude" => -76.495099},
                    "49" => {"latitude" => 43.657736, "longitude" => -79.380178},
                    "51" => {"latitude" => 43.533278, "longitude" => -80.223556},
                    "53" => {"latitude" => 45.4222, "longitude" => -75.6824},
                    "54" => {"latitude" => 43.661667, "longitude" => -79.395},
                    "55" => {"latitude" => 42.306667, "longitude" => -83.065833},
                    "56" => {"latitude" => 43.475336, "longitude" => -80.527244},
                    "57" => {"latitude" => 43.773067, "longitude" => -79.503631},
                    "61" => {"latitude" => 45.504167, "longitude" => -73.574722},
                    "62" => {"latitude" => 45.504722, "longitude" => -73.612778},
                    "63" => {"latitude" => 45.513889, "longitude" => -73.560278},
                    "64" => {"latitude" => 45.379406, "longitude" => -71.927661},
                    "65" => {"latitude" => 46.78, "longitude" => -71.274722},
                    "67" => {"latitude" => 50.415553, "longitude" => -104.587953},
                    "68" => {"latitude" => 52.129825, "longitude" => -106.6328},
                    "72" => {"latitude" => 43.119, "longitude" => -79.249},
                    "73" => {"latitude" => 45.497406, "longitude" => -73.577102},
                    "74" => {"latitude" => 43.012439, "longitude" => -81.200178},
                    "75" => {"latitude" => 45.900519, "longitude" => -64.377822},
                    "76" => {"latitude" => 49.517619, "longitude" => -115.741964},
                    "77" => {"latitude" => 43.470919, "longitude" => -79.696089},
                    "80" => {"latitude" => 44.357764, "longitude" => -78.289561},
                    "83" => {"latitude" => 45.946, "longitude" => -66.641},
                    "84" => {"latitude" => 48.42, "longitude" => -89.262222},
                    "85" => {"latitude" => 48.463325, "longitude" => -123.311751},
                    "88" => {"latitude" => 49.1403, "longitude" => -122.600761},
                    "141" => {"latitude" => 43.944847, "longitude" => -78.891703}
                  }
  
  def self.up
    add_column Campus.table_name, :longitude, :decimal, :precision => 10, :scale => 6
    add_column Campus.table_name, :latitude, :decimal, :precision => 10, :scale => 6
    
    add_index Campus.table_name, :longitude
    add_index Campus.table_name, :latitude
    
    Campus.reset_column_information
    
    CAMPUS_COORDS.each_pair do |id, hash|
      campus = Campus.find(id.to_i)
      if campus
        campus.longitude = hash["longitude"]
        campus.latitude = hash["latitude"]
        campus.save!
      end
    end
  end

  def self.down
    remove_index Campus.table_name, :longitude
    remove_index Campus.table_name, :latitude
    
    remove_column Campus.table_name, :longitude
    remove_column Campus.table_name, :latitude
  end
end

