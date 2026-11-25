use std::sync::Arc;

use auth::models::MinecraftAccessToken;
use bridge::{account::Account, message::MessageToFrontend};
use indexmap::IndexMap;
use schema::{minecraft_profile::MinecraftProfileResponse, unique_bytes::UniqueBytes};
use serde::{Deserialize, Serialize};
use uuid::Uuid;

pub struct MinecraftLoginInfo {
    pub uuid: Uuid,
    pub username: Arc<str>,
    pub access_token: Option<MinecraftAccessToken>,
}

#[derive(Default, Debug, Serialize, Deserialize)]
pub struct BackendAccountInfo {
    pub accounts: IndexMap<Uuid, BackendAccount>,
    pub selected_account: Option<Uuid>,
}

impl BackendAccountInfo {
    pub fn create_update_message(&self) -> MessageToFrontend {
        let mut accounts = Vec::with_capacity(self.accounts.len());
        for uuid in self.accounts.keys().copied() {
            let Some(account) = self.accounts.get(&uuid) else {
                continue;
            };
            accounts.push(Account {
                uuid,
                username: account.username.clone(),
                offline: account.offline,
                head: account.head.clone(),
            });
        }
        MessageToFrontend::AccountsUpdated {
            accounts: accounts.into(),
            selected_account: self.selected_account,
        }
    }
}

#[derive(Debug, Serialize, Deserialize)]
pub struct BackendAccount {
    pub username: Arc<str>,
    #[serde(default)]
    pub offline: bool,
    pub head: Option<UniqueBytes>,
}

impl BackendAccount {
    pub fn new_from_profile(profile: &MinecraftProfileResponse) -> Self {
        Self {
            username: profile.name.clone(),
            offline: false,
            head: None,
        }
    }
}

/// Username used for the default offline account that is created automatically
/// when the user launches the game without having added any account.
pub const DEFAULT_OFFLINE_USERNAME: &str = "Player";

/// Generate a random version-3 style UUID for an offline account
/// (matches what the frontend does when adding an offline account).
pub fn offline_uuid_for_name(_name: &str) -> Uuid {
    let uuid: u128 = rand::random();
    let uuid = (uuid & !0xF0000000000000000000) | 0x30000000000000000000; // set version to 3
    Uuid::from_u128(uuid)
}
