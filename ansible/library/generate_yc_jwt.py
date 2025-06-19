#!/usr/bin/python
from ansible.module_utils.basic import AnsibleModule
import jwt
import time
import json

def main():
    module_args = dict(
        key_file=dict(type='str', required=True),
        iam_api_url=dict(type='str', required=True),
        token_lifetime=dict(type='int', required=True)
    )

    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    try:
        with open(module.params['key_file']) as f:
            key_data = json.load(f)

        # Clean private key if needed
        private_key = key_data["private_key"]
        if "PLEASE DO NOT REMOVE" in private_key:
            private_key = "\n".join(private_key.split("\n")[1:])

        jwt_token = jwt.encode(
            {
                "iss": key_data["service_account_id"],
                "aud": module.params['iam_api_url'],
                "iat": int(time.time()),
                "exp": int(time.time()) + module.params['token_lifetime'],
                "kid": key_data["id"]
            },
            private_key,
            algorithm="PS256",
            headers={"alg": "PS256", "typ": "JWT", "kid": key_data["id"]}
        )

        module.exit_json(changed=False, jwt_token=jwt_token)
    except Exception as e:
        module.fail_json(msg=f"Failed to generate JWT token: {str(e)}")

if __name__ == '__main__':
    main()
