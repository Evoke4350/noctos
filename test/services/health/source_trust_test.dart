import 'package:flutter_test/flutter_test.dart';
import 'package:noctos/services/health/source_trust.dart';

void main() {
  group('sourceTrust tiers', () {
    test('dedicated sleep trackers rank highest', () {
      expect(sourceTrust('Oura', 'Oura Ring'), 40);
      expect(sourceTrust('WHOOP', null), 40);
      expect(sourceTrust('Eight Sleep', null), 40);
    });

    test('wrist wearables rank above phones', () {
      expect(sourceTrust('Galaxy Wearable', 'Galaxy Watch6'), 30);
      expect(sourceTrust('Mi Fitness', 'Mi Band 7'), 30);
      expect(sourceTrust('Fitbit', null), 30);
    });

    test('phone-class sensors', () {
      expect(sourceTrust('Pixel', 'Pixel 8'), 20);
      expect(sourceTrust('Sleep as Android', null), 20);
    });
  });

  group('token matching avoids substring false positives', () {
    test('"Husband\'s Phone" is a phone, not a "band"', () {
      expect(sourceTrust("Husband's Phone", null), 20);
    });

    test('earbuds are not wrist wearables', () {
      expect(sourceTrust('Galaxy Buds', null), 10);
      expect(sourceTrust('Pixel Buds', null), 10); // earbuds, not a sleep sensor
    });

    test('"Bandwidth Sleep" does not match the "band" token', () {
      expect(sourceTrust('Bandwidth Sleep', null), 10);
    });
  });

  group('unknown / manual', () {
    test('empty and whitespace-only sources are tier 0', () {
      expect(sourceTrust(null, null), 0);
      expect(sourceTrust('', ''), 0);
      expect(sourceTrust('   ', '  '), 0);
    });

    test('an unrecognized real source falls to the generic tier', () {
      expect(sourceTrust('SomeRandomApp', 'Gadget'), 10);
    });
  });
}
