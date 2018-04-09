public with sharing class CountriesConfigurationLoader {
    public class CountryWrapper {
        public String name;
        public String isoCode;
        public String region;
        public Boolean isVatNumberRequired;
        public CountryWrapper(String name, String isoCode, String region, Boolean isVatNumberRequired) {
            this.name = name;
            this.isoCode = isoCode;
            this.region = region;
            this.isVatNumberRequired = isVatNumberRequired;
        }
    }

    public List<CountryWrapper> getConfiguration() {
        List<CountryWrapper> countriesConfiguration = new List<CountryWrapper>();

        StaticResource sr = [Select s.Name, s.Id, s.Body From StaticResource s where name = 'Countries_Configuration'];
        blob bodyBlob = sr.Body;
        String bodyString = bodyBlob.toString();
        List<String> lines = bodyString.split('\n');
        for (Integer i = 1; i < lines.size(); i++) {
            String l = lines.get(i);
            List<String> valuesArray = l.split(',');
            System.debug(valuesArray);
            for (Integer j = 0; j < valuesArray.size(); j++) {
                valuesArray[j] = valuesArray.get(j).replace('"', '');
            }
            if(valuesArray.size() == 4){
                CountryWrapper country = new CountryWrapper(
                    valuesArray.get(0).trim(),
                    valuesArray.get(1).trim(),
                    valuesArray.get(2).trim(),
                    Boolean.valueOf(valuesArray.get(3).trim())
                );
                countriesConfiguration.add(country);
            }
        }
        return countriesConfiguration;
    }
}