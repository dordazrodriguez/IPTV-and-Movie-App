// Setup AWS User Pool Id & Client Id settings here:
import 'package:amazon_cognito_identity_dart_2/cognito.dart';

const AWSUserPoolId = 'us-east-2_B6l9C5kUm';
const AWSClientId = 'moj9fuqjkeik4esj7pm1vbuvp'; //'43i010gl6ujbp7openbkja14ni';

const IdentityPoolId = 'us-east-2:58ebf09c-38a4-4e20-add4-5a47a2b03095';

// Setup endpoints here:
const Region = 'us-east-2';
const Endpoint =
'https://esports-test.auth.us-east-2.amazoncognito.com';

final userPool = CognitoUserPool(AWSUserPoolId, AWSClientId);