### Generate a GitHub Personal Access Token for Private Composer Packages

If you're trying to load a private repository with Composer/Laravel, we'll need to generate a GitHub Personal Access Token (similar to OAuth token) to access the repository during a `composer install` without entering credentials.

> If you have used other Github packages from `{my-org}` before, you may be able to skip this step.

1. Visit [https://github.com/settings/tokens](https://github.com/settings/tokens).

2. Click **Generate new token**.

        Token Description: (your computer name)
        Scopes:
            [X] repo
                [X] repo:status
                [X] repo_deployment
                [X] public_repo
                [X] repo:invite

3. Click **Generate token**.

4. Copy the generated string to a safe place, such as a password safe.

5. Open Terminal and add the github token. Note: The file may be empty.

        #  nano ~/.composer/auth.json

        {
            "github-oauth": {
                "github.com": "abc123def456ghi7890jkl987mno654pqr321stu"
            }
        }

6. Test if the authentication is working by doing a clone.

        cd ~/Sites/
        git clone https://github.com/my-org/my-private-repo
        (You should not be prompted for credentials)