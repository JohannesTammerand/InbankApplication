import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:inbank_frontend/api_service.dart';
import 'package:test/test.dart';

void main() {
  group('ApiService', () {
    late ApiService apiService;

    test('requestLoanDecision returns a valid decision', () async {
      final mockClient = MockClient((request) async {
        final response = {
          'loanAmount': 10000,
          'loanPeriod': 12,
          'errorMessage': 'null',
        };
        return http.Response(jsonEncode(response), 200);
      });
      apiService = ApiService(client: mockClient);

      const personalCode = '50307172740';
      const loanAmount = 10000;
      const loanPeriod = 12;
      const countryOfResidence = 'Estonia';

      final result = await apiService.requestLoanDecision(
          personalCode, loanAmount, loanPeriod, countryOfResidence);

      expect(result, isA<Map<String, String>>());
      expect(result['loanAmount'], '10000');
      expect(result['loanPeriod'], '12');
      expect(result['errorMessage'], '');
    });

    test('requestLoanDecision denies application', () async {
      final mockClient = MockClient((request) async {
        final response = {
          'loanAmount': 'null',
          'loanPeriod': 'null',
          'errorMessage': 'Loan application denied',
        };
        return http.Response(jsonEncode(response), 400);
      });

      apiService = ApiService(client: mockClient);

      const personalCode = '50307172740';
      const loanAmount = 50000;
      const loanPeriod = 24;
      const countryOfResidence = 'Latvia';

      final result = await apiService.requestLoanDecision(
          personalCode, loanAmount, loanPeriod, countryOfResidence);

      expect(result, isA<Map<String, String>>());
      expect(result['loanAmount'], '0');
      expect(result['loanPeriod'], '0');
      expect(result['errorMessage'], 'Loan application denied');
    });

    test('requestLoanDecision returns an invalid age exception (overage Latvia)', () async {
      final mockClient = MockClient((request) async {
        final response = {
          'loanAmount': 'null',
          'loanPeriod': 'null',
          'errorMessage': 'Invalid age!',
        };
        return http.Response(jsonEncode(response), 400);
      });

      apiService = ApiService(client: mockClient);

      const personalCode = '34501234215';
      const loanAmount = 50000;
      const loanPeriod = 24;
      const countryOfResidence = 'Latvia';

      final result = await apiService.requestLoanDecision(
          personalCode, loanAmount, loanPeriod, countryOfResidence);

      expect(result, isA<Map<String, String>>());
      expect(result['loanAmount'], '0');
      expect(result['loanPeriod'], '0');
      expect(result['errorMessage'], 'Invalid age!');
    });

    test('requestLoanDecision returns an invalid age exception (overage Estonia)', () async {
      final mockClient = MockClient((request) async {
        final response = {
          'loanAmount': 'null',
          'loanPeriod': 'null',
          'errorMessage': 'Invalid age!',
        };
        return http.Response(jsonEncode(response), 400);
      });

      apiService = ApiService(client: mockClient);

      const personalCode = '34501234215';
      const loanAmount = 50000;
      const loanPeriod = 24;
      const countryOfResidence = 'Estonia';

      final result = await apiService.requestLoanDecision(
          personalCode, loanAmount, loanPeriod, countryOfResidence);

      expect(result, isA<Map<String, String>>());
      expect(result['loanAmount'], '0');
      expect(result['loanPeriod'], '0');
      expect(result['errorMessage'], 'Invalid age!');
    });

    test('requestLoanDecision returns an invalid age exception (overage Lithuania)', () async {
      final mockClient = MockClient((request) async {
        final response = {
          'loanAmount': 'null',
          'loanPeriod': 'null',
          'errorMessage': 'Invalid age!',
        };
        return http.Response(jsonEncode(response), 400);
      });

      apiService = ApiService(client: mockClient);

      const personalCode = '34501234215';
      const loanAmount = 50000;
      const loanPeriod = 24;
      const countryOfResidence = 'Lithuania';

      final result = await apiService.requestLoanDecision(
          personalCode, loanAmount, loanPeriod, countryOfResidence);

      expect(result, isA<Map<String, String>>());
      expect(result['loanAmount'], '0');
      expect(result['loanPeriod'], '0');
      expect(result['errorMessage'], 'Invalid age!');
    });

    test('requestLoanDecision returns an invalid age exception (underage)', () async {
      final mockClient = MockClient((request) async {
        final response = {
          'loanAmount': 'null',
          'loanPeriod': 'null',
          'errorMessage': 'Invalid age!',
        };
        return http.Response(jsonEncode(response), 400);
      });

      apiService = ApiService(client: mockClient);

      const personalCode = '51809260135';
      const loanAmount = 50000;
      const loanPeriod = 24;
      const countryOfResidence = 'Latvia';

      final result = await apiService.requestLoanDecision(
          personalCode, loanAmount, loanPeriod, countryOfResidence);

      expect(result, isA<Map<String, String>>());
      expect(result['loanAmount'], '0');
      expect(result['loanPeriod'], '0');
      expect(result['errorMessage'], 'Invalid age!');
    });

    test('requestLoanDecision returns an invalid personal code exception', () async {
      final mockClient = MockClient((request) async {
        final response = {
          'loanAmount': 'null',
          'loanPeriod': 'null',
          'errorMessage': 'Invalid personal ID code!',
        };
        return http.Response(jsonEncode(response), 400);
      });

      apiService = ApiService(client: mockClient);

      const personalCode = '34501234219';
      const loanAmount = 50000;
      const loanPeriod = 24;
      const countryOfResidence = 'Latvia';

      final result = await apiService.requestLoanDecision(
          personalCode, loanAmount, loanPeriod, countryOfResidence);

      expect(result, isA<Map<String, String>>());
      expect(result['loanAmount'], '0');
      expect(result['loanPeriod'], '0');
      expect(result['errorMessage'], 'Invalid personal ID code!');
    });

    test('requestLoanDecision returns an invalid loan period exception (too low)', () async {
    final mockClient = MockClient((request) async {
      final response = {
        'loanAmount': 'null',
        'loanPeriod': 'null',
        'errorMessage': 'Invalid loan period!',
      };
      return http.Response(jsonEncode(response), 400);
    });

    apiService = ApiService(client: mockClient);

    const personalCode = '50307172740';
    const loanAmount = 50000;
    const loanPeriod = 0;
    const countryOfResidence = 'Latvia';

    final result = await apiService.requestLoanDecision(
        personalCode, loanAmount, loanPeriod, countryOfResidence);

    expect(result, isA<Map<String, String>>());
    expect(result['loanAmount'], '0');
    expect(result['loanPeriod'], '0');
    expect(result['errorMessage'], 'Invalid loan period!');
  });

  test('requestLoanDecision returns an invalid loan period exception (too high)', () async {
    final mockClient = MockClient((request) async {
      final response = {
        'loanAmount': 'null',
        'loanPeriod': 'null',
        'errorMessage': 'Invalid loan period!',
      };
      return http.Response(jsonEncode(response), 400);
    });

    apiService = ApiService(client: mockClient);

    const personalCode = '50307172740';
    const loanAmount = 50000;
    const loanPeriod = 456456456;
    const countryOfResidence = 'Latvia';

    final result = await apiService.requestLoanDecision(
        personalCode, loanAmount, loanPeriod, countryOfResidence);

    expect(result, isA<Map<String, String>>());
    expect(result['loanAmount'], '0');
    expect(result['loanPeriod'], '0');
    expect(result['errorMessage'], 'Invalid loan period!');
  });

  test('requestLoanDecision returns an invalid loan amount exception (too low)', () async {
    final mockClient = MockClient((request) async {
      final response = {
        'loanAmount': 'null',
        'loanPeriod': 'null',
        'errorMessage': 'Invalid loan amount!',
      };
      return http.Response(jsonEncode(response), 400);
    });

    apiService = ApiService(client: mockClient);

    const personalCode = '50307172740';
    const loanAmount = -20;
    const loanPeriod = 24;
    const countryOfResidence = 'Latvia';

    final result = await apiService.requestLoanDecision(
        personalCode, loanAmount, loanPeriod, countryOfResidence);

    expect(result, isA<Map<String, String>>());
    expect(result['loanAmount'], '0');
    expect(result['loanPeriod'], '0');
    expect(result['errorMessage'], 'Invalid loan amount!');
  });

  test('requestLoanDecision returns an invalid loan amount exception (too high)', () async {
    final mockClient = MockClient((request) async {
      final response = {
        'loanAmount': 'null',
        'loanPeriod': 'null',
        'errorMessage': 'Invalid loan amount!',
      };
      return http.Response(jsonEncode(response), 400);
    });

    apiService = ApiService(client: mockClient);

    const personalCode = '50307172740';
    const loanAmount = 456456456;
    const loanPeriod = 24;
    const countryOfResidence = 'Latvia';

    final result = await apiService.requestLoanDecision(
        personalCode, loanAmount, loanPeriod, countryOfResidence);

    expect(result, isA<Map<String, String>>());
    expect(result['loanAmount'], '0');
    expect(result['loanPeriod'], '0');
    expect(result['errorMessage'], 'Invalid loan amount!');
  });
});
}
