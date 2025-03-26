package ee.taltech.inbankbackend.service;

import com.github.vladislavgoltjajev.personalcode.common.Gender;
import com.github.vladislavgoltjajev.personalcode.exception.PersonalCodeException;
import com.github.vladislavgoltjajev.personalcode.locale.estonia.EstonianPersonalCodeGenerator;
import ee.taltech.inbankbackend.config.DecisionEngineConstants;
import ee.taltech.inbankbackend.exceptions.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

@SpringBootTest
@ExtendWith(MockitoExtension.class)
class DecisionEngineTest {

    @InjectMocks
    private DecisionEngine decisionEngine;

    private String debtorPersonalCode;
    private String segment1PersonalCode;
    private String segment2PersonalCode;
    private String segment3PersonalCode;

    private final EstonianPersonalCodeGenerator generator = new EstonianPersonalCodeGenerator();

    @BeforeEach
    void setUp() {
        debtorPersonalCode = "37605030299";
        segment1PersonalCode = "50307172740";
        segment2PersonalCode = "38411266610";
        segment3PersonalCode = "36006069517";
    }

    @Test
    void testDebtorPersonalCode() {
        assertThrows(NoValidLoanException.class,
                () -> decisionEngine.calculateApprovedLoan(debtorPersonalCode, 4000L, 12, "Latvia"));
    }

    @Test
    void testSegment1PersonalCode() throws InvalidLoanPeriodException, NoValidLoanException,
            InvalidPersonalCodeException, InvalidLoanAmountException, InvalidAgeException, PersonalCodeException {
        Decision decision = decisionEngine.calculateApprovedLoan(segment1PersonalCode, 4000L, 12, "Estonia");
        assertEquals(2000, decision.getLoanAmount());
        assertEquals(20, decision.getLoanPeriod());
    }

    @Test
    void testSegment2PersonalCode() throws InvalidLoanPeriodException, NoValidLoanException,
            InvalidPersonalCodeException, InvalidLoanAmountException, InvalidAgeException, PersonalCodeException {
        Decision decision = decisionEngine.calculateApprovedLoan(segment2PersonalCode, 4000L, 12, "Estonia");
        assertEquals(3600, decision.getLoanAmount());
        assertEquals(12, decision.getLoanPeriod());
    }

    @Test
    void testSegment3PersonalCode() throws InvalidLoanPeriodException, NoValidLoanException,
            InvalidPersonalCodeException, InvalidLoanAmountException, InvalidAgeException, PersonalCodeException {
        Decision decision = decisionEngine.calculateApprovedLoan(segment3PersonalCode, 4000L, 12, "Lithuania");
        assertEquals(10000, decision.getLoanAmount());
        assertEquals(12, decision.getLoanPeriod());
    }

    @Test
    void testInvalidPersonalCode() {
        String invalidPersonalCode = "12345678901";
        assertThrows(InvalidPersonalCodeException.class,
                () -> decisionEngine.calculateApprovedLoan(invalidPersonalCode, 4000L, 12, "Estonia"));
    }

    @Test
    void testInvalidLoanAmount() {
        Long tooLowLoanAmount = DecisionEngineConstants.MINIMUM_LOAN_AMOUNT - 1L;
        Long tooHighLoanAmount = DecisionEngineConstants.MAXIMUM_LOAN_AMOUNT + 1L;

        assertThrows(InvalidLoanAmountException.class,
                () -> decisionEngine.calculateApprovedLoan(segment1PersonalCode, tooLowLoanAmount, 12, "Lithuania"));

        assertThrows(InvalidLoanAmountException.class,
                () -> decisionEngine.calculateApprovedLoan(segment1PersonalCode, tooHighLoanAmount, 12, "Estonia"));
    }

    @Test
    void testInvalidLoanPeriod() {
        int tooShortLoanPeriod = DecisionEngineConstants.MINIMUM_LOAN_PERIOD - 1;
        int tooLongLoanPeriod = DecisionEngineConstants.MAXIMUM_LOAN_PERIOD + 1;

        assertThrows(InvalidLoanPeriodException.class,
                () -> decisionEngine.calculateApprovedLoan(segment1PersonalCode, 4000L, tooShortLoanPeriod, "Latvia"));

        assertThrows(InvalidLoanPeriodException.class,
                () -> decisionEngine.calculateApprovedLoan(segment1PersonalCode, 4000L, tooLongLoanPeriod, "Latvia"));
    }

    @Test
    void testFindSuitableLoanPeriod() throws InvalidLoanPeriodException, NoValidLoanException,
            InvalidPersonalCodeException, InvalidLoanAmountException, InvalidAgeException, PersonalCodeException {
        Decision decision = decisionEngine.calculateApprovedLoan(segment2PersonalCode, 2000L, 12, "Estonia");
        assertEquals(3600, decision.getLoanAmount());
        assertEquals(12, decision.getLoanPeriod());
    }

    @Test
    void testNoValidLoanFound() {
        assertThrows(NoValidLoanException.class,
                () -> decisionEngine.calculateApprovedLoan(debtorPersonalCode, 10000L, 60, "Estonia"));
    }

    @Test
    void testInvalidAgeInEstonia() {
        assertThrows(InvalidAgeException.class,
                () -> decisionEngine.calculateApprovedLoan(generator.generatePersonalCode(Gender.MALE, LocalDate.of(1949, 8, 5)), 10000L, 20, "Estonia"));
    }

    @Test
    void testInvalidAgeInLatvia() {
        assertThrows(InvalidAgeException.class,
                () -> decisionEngine.calculateApprovedLoan(generator.generatePersonalCode(Gender.MALE, LocalDate.of(1944, 8, 5)), 10000L, 20, "Latvia"));
    }

    @Test
    void testInvalidAgeInLithuania() {
        assertThrows(InvalidAgeException.class,
                () -> decisionEngine.calculateApprovedLoan(generator.generatePersonalCode(Gender.MALE, LocalDate.of(1953, 8, 5)), 10000L, 20, "Lithuania"));
    }

    @Test
    void testUnderage() {
        assertThrows(InvalidAgeException.class,
                () -> decisionEngine.calculateApprovedLoan(generator.generatePersonalCode(Gender.MALE, LocalDate.of(2010, 8, 5)), 10000L, 20, "Lithuania"));
    }

}

