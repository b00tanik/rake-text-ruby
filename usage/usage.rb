require_relative '../lib/rake_text'


text = IO.read('data/corpus.log')


rake = RakeText.new


puts rake.analyse(text, ['по', 'в', 'опыт', 'навыки', '•', 'и', 'я', 'а', 'у',
                         'умение', 'желание']).inspect
# → {"compatibility"=>1.0, "systems"=>1.0, "linear constraints"=>4.5, "set"=>2.0, "natural numbers"=>4.0, "criteria"=>1.0, "system"=>1.0, "linear diophantine equations"=>8.5, "strict inequations"=>4.0, "nonstrict inequations"=>4.0, "considered"=>1.5, "upper bounds"=>4.0, "components"=>1.0, "minimal set"=>4.666666666666666, "solutions"=>1.0, "algorithms"=>1.0, "construction"=>1.0, "minimal generating sets"=>8.666666666666666, "types"=>1.6666666666666667, "constructing"=>1.0, "minimal supporting set"=>7.666666666666666, "solving"=>1.0, "considered types"=>3.166666666666667, "mixed types"=>3.666666666666667}

