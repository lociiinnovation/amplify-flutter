//
//  FlutterSignUpRequest.swift
//  amplify_auth
//
//  Created by Noyes, Dustin on 7/2/20.
//

import Foundation
import Amplify
import AmplifyPlugins

struct FlutterSignUpRequest {
  var username: String?
  var password: String
  var userAttributes: [AuthUserAttribute] = []
  var options: Dictionary<String, Any>? = [:]
  let standardAttributes = ["address", "birthdate", "email", "family_name", "gender", "given_name", "locale", "middle_name", "name", "nickname", "phone_number", "preferred_username", "picture", "profile", "updated_at", "website", "zoneinfo"]
  init(dict: NSMutableDictionary){
    self.username = dict["username"] as? String
    self.password = dict["password"] as! String
    self.options = dict["options"] as? Dictionary<String, Any>
    self.userAttributes = self.formatUserAttributes(options: dict["options"] as! Dictionary<String, Any>)
  }
    
  func formatUserAttributes(options: Dictionary<String, Any>) -> [AuthUserAttribute] {
    let rawAttributes: Dictionary<String, Any> = options["userAttributes"] as! Dictionary<String, String>
    var formattedAttributes: Array<AuthUserAttribute> = Array()
    for attr in rawAttributes {
      if (standardAttributes.contains(attr.key)) {
        formattedAttributes.append(AuthUserAttribute(.unknown(attr.key), value: attr.value as! String))
      } else {
        formattedAttributes.append(AuthUserAttribute(.custom(attr.key), value: attr.value as! String))
      }
    }
    return formattedAttributes
  }
  func getUsername() -> String {
    var username: String = ""
    let rawAttributes: Dictionary<String, Any> = options?["userAttributes"] as! Dictionary<String, String>

    if (self.options?["usernameAttribute"] == nil && self.username != nil) {
        username = self.username! as String;
    } else if (self.options?["usernameAttribute"] != nil) {
      if (self.options?["usernameAttribute"] as! String == "email") {
        username = rawAttributes["email"] as! String
      } else {
        username = rawAttributes["phone_number"] as! String
      }
    }
    return username
  }
    
  static func validate(dict: NSMutableDictionary) -> Bool {
    var valid: Bool = true;
    if (dict["options"] == nil) {
      valid = false;
    } else if (dict["password"] == nil) {
      valid = false;
    }
    return valid;
  }
}
