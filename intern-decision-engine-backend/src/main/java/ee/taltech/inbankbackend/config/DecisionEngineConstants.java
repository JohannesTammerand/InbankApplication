package ee.taltech.inbankbackend.config;

import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import java.util.TreeMap;

/**
 * Holds all necessary constants for the decision engine.
 */
@Component
public class DecisionEngineConstants {
    public static final Integer MINIMUM_LOAN_AMOUNT = 2000;
    public static final Integer MAXIMUM_LOAN_AMOUNT = 10000;
    public static final Integer MAXIMUM_LOAN_PERIOD = 60;
    public static final Integer MINIMUM_LOAN_PERIOD = 12;
    public static final Integer SEGMENT_1_CREDIT_MODIFIER = 100;
    public static final Integer SEGMENT_2_CREDIT_MODIFIER = 300;
    public static final Integer SEGMENT_3_CREDIT_MODIFIER = 1000;

    public static final TreeMap<String, Integer> LIFE_EXPECTANCY_BY_COUNTRY = new TreeMap<>();

    @PostConstruct
    public void init(){
        LIFE_EXPECTANCY_BY_COUNTRY.put("Estonia", 75);
        LIFE_EXPECTANCY_BY_COUNTRY.put("Latvia", 80);
        LIFE_EXPECTANCY_BY_COUNTRY.put("Lithuania", 70);
    }
}
