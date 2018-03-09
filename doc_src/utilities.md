# Utilities

## Reset the admin password from the command line

In the event someone has forgotten their password, a user with the admin permission can reset their password. However, if all admins have forgotten their passwords, you will need to reset one of their passwords from the command line:

1. Log onto the host system for Arcus as a user who has docker permission
2. Run the following command: `docker exec -it arcus_web_1 rake reset_admin {email of user to reset}`
3. The system will prompt you to enter the new password twice.
4. The system will confirm that the password has been set once complete. You should now be able to log in through the web interface.
