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

        //Get configuration from static resources
        List<StaticResource> resourcesList = [Select s.Name, s.Id, s.Body From StaticResource s where name = 'Countries_Configuration'];
        if (!resourcesList.isEmpty()) {
            Blob bodyBlob = resourcesList.get(0).Body;

            //Convert binary data to string
            String bodyString = bodyBlob.toString();

            //Split text into lines
            List<String> lines = bodyString.split('\n');

            //Process each row of CSV file (skip header)
            for (Integer i = 1; i < lines.size(); i++) {
                String l = lines.get(i);

                //Split row into columns
                List<String> valuesArray = l.split(',');
                for (Integer j = 0; j < valuesArray.size(); j++) {
                    valuesArray[j] = valuesArray.get(j).replace('"', '');
                }

                //Each row should have four columns (name, iso code, region, is VAT number required)
                if (valuesArray.size() == 4) {
                    //Create configuration wrapper and add to list
                    CountryWrapper country = new CountryWrapper(
                        valuesArray.get(0).trim(),
                        valuesArray.get(1).trim(),
                        valuesArray.get(2).trim(),
                        Boolean.valueOf(valuesArray.get(3).trim())
                    );
                    countriesConfiguration.add(country);
                }
            }
        }
        return countriesConfiguration;
    }
}