import time
import numpy as np
import pybullet as p
from stable_baselines3 import PPO, SAC
from stable_baselines3.common.env_checker import check_env
from stable_baselines3.common.env_util import make_vec_env
from opencat_gym_env import OpenCatGymEnv
from gymnasium.wrappers.time_limit import TimeLimit

# argparse the model to load
import argparse
parser = argparse.ArgumentParser()
parser.add_argument("model", help="model to load")
parser.add_argument("--stochastic", help="use stochastic policy", action="store_true")
parser.add_argument("--observe_joints", action="store_true")
args = parser.parse_args()
# Create OpenCatGym environment from class
print("load from:", args.model)
parallel_env = 1
env = make_vec_env(lambda **kwargs: TimeLimit(OpenCatGymEnv(**kwargs), max_episode_steps=400), n_envs=parallel_env, env_kwargs={"render_mode": "human", "observe_joints": args.observe_joints})
# model = PPO.load("trained/trained_agent_PPO")
model = PPO.load(args.model)

obs = env.reset()
sum_reward = 0
sum_info = {}
for i in range(5000):
    action, _state = model.predict(obs, deterministic=args.stochastic)
    obs, reward, done, info = env.step(action)
    info = {k: v for k, v in info[0].items() if isinstance(v, np.floating)}
    # print(info)
    sum_reward += reward[0]
    sum_info = {k: v + (sum_info.get(k) or 0) for k, v in info.items()}
    env.render(mode="human")
    if done[0]:
        print("Reward", sum_reward)
        print("Sum info", sum_info)
        sum_reward = 0
        sum_info = {}
        obs = env.reset()
