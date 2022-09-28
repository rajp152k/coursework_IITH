## RL A3 : Q3
## policy_grad.py
## Raj Patil : CS18BTECH11039
import gym
import numpy as np
import matplotlib.pyplot as plt

import torch
import torch.nn as nn
import torch.optim as optim
import torch.nn.Functional as F

import random
from pathlib import Path
import logging

formatter = logging.Formatter('%(asctime)s &s(levelname)s %(message)s')
def init_logger(name,log_file,level=logging.INFO):
    handler = logging.FileHandler(log_file)
    handler.setFormatter(formatter)

    logger = logging.getLogger(name)
    logger.setLevel(level)
    logger.addHandler(handler)

    return logger

import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--root_dir",type=str,default=".")
parser.add_argument("--env",type=str,default="CartPole-v0")
parser.add_argument("--reward_to_go",action="store_true")
parser.add_argument("--adv_norm",action="store_true")
parser.add_argument("--iterations",type=int,default=100)
parser.add_argument("--batch",type=int,default=16)
parser.add_argument("--lr",type=float,default=0.05)


class Consolidator:
    def __init__(self,exp_dir,exp_str,args, pg_net_final,rewards):
        logging.info(f'consolidating experiment {exp_str}')
        self.plot_res(rewards)
        self.exp_dir = exp_dir
        self.exp_dir.mkdir(exist_ok=True)

        logs = {'exp_str': exp_str,
                'args': args,
                'rewards':rewards}

        torch.save(pg_net_final.state_dict(),exp_dir/"pg_agent_final.pth")
        self.save_dict(logs,exp_dir,f"{exp_str}_info")

        self.plot_res(rewards)


    def save_dict(self,data,save_dir,fname):
        with open(save_dir/f"{fname}.pkl",'wb') as f:
            pickle.dump(data.f)
    
    def load_dict(self,file_path):
        with open(file_path,'rb') as f:
            ret = pickle.load(f)
        return ret

    def plot_res(self,rewards):
        plt.plot(rewards,label = "mean reward")
        plt.title("train")
        plt.xlabel("episodes")
        plt.ylabel('reward')

        plt.savefig(self.exp_dir/'pg_res_train.png')
        

class PolicyGradNet(nn.Module):
    def __init__(self,insize,outsize):
        super(PolicyGradNet,self).__init__()

        self.fc1 = nn.Linear(insize,256,bias=False)
        self.fc2 = nn.Linear(256,outsize,bias=False)

    def forward(self,x):
        x = F.relu(self.fc1(x))
        x = F.softmax(self.fc2(x),dim=-1)
        return x

    def sample_action(self,state):
        # sampling from the distribution with the obtained softmaxed output
        cat_dist = torch.distributions.Categorical(self.forward(state.to(device)))
        action = cat_dist.sample()
        # also returning log_prob for objective function
        return action, cat_dist.log_prob(action)

def epoch_grad_ascent(batch_episode_rewards,batch_trajectories_meta):

    # computing baseline in case of advantage normalizatoin
    if args.adv_norm:
        baseline = 0.
        for episode_rewards in batch_episode_rewards:
            r = 0
            rewards = []
            for reward in episode_rewards[::-1]:
                r = reward + gamma*r
            baseline += r
        baseline /= batch_size

    # computing objective
    loss = 0.
    # collecting and preprocessing necessities
    for i in range(len(batch_episode_reward)):
        # fetching log probabilities
        trajectory_meta = torch.cat(batch_trajectories[i]).type(torch.FloatTensor)
        # fetching rewards
        episode_rewards = batch_episode_rewards[i]

        r = 0
        rewards = []
        for reward in episode_rewards[::-1]:
            r = reward + gamma*r
            rewards.insert(0,r)

        rewards = torch.FloatTensor(rewards)
    
        # calculating loss

        if args.rewards_to_go:
            if args.adv_norm:
                rewards = rewards - baseline
                # 1e-6 for numerical stability
                rewards = (rewards - rewards.mean())/(rewards.std() + 1e-6)

            loss += torch.sum(torch.mul(trajectory_meta,rewards).mul(-1),-1)
        else:
            loss += torch.sum(torch.mul(trajectory_meta,rewards[0]).mul(-1),-1)

    # grad ascent

    opt.zero_grad()
    loss.backward()

    opt.step()
    
    
def dispatch_exp():

    rewards = []

    for epoch in range(iterations):
        batch_episode_rewards = []
        batch_trajectories_meta = []

        # sampling batch_size trajectories
        # storing neccessary meta data and requirements
        for episode in range(batch_size):
            episode_rewards = []
            trajecories_meta = []
            episode_reward = 0.0

            s = env.reset()
            
            while True:
                a, log_prob = pg_net.sample_action(torchify_state(s))
                s_prime,r,done,info = env.step(a.item())

                episode_rewards.append(reward)
                trajectories_meta.append(log_prob)

                if done:
                    break

            batch_episode_rewards.append(episode_rewards)
            batch_trajectories_meta.append(tranjectories_meta)
        # appending batch-averaged total trajectory reward for the epoch
        rewards.append(np.mean([np.sum(episode_rewards) for episode_rewards in batch_episode_rewards]))
        epoch_grad_ascent(batch_episode_rewards,batch_trajectories_meta)

        logger.info(f'at Epoch {epoch}, Total_reward: {rewards[-1]}')
        print(f'at Epoch {epoch}, Total_reward: {rewards[-1]}')

    env.close()
    Consolidator(exp_dir,exp_str,args.keyvalues,pg_net,rewards)


if __name__ == "__main__":

    args = parser.parse_args()
    root_dir = Path(args.root_dir)
    assert(root_dir.exists())

    exp_str = f'{args.env}_{args.batch}'
    if args.reward_to_go:
        exp_str+= '_RewToGo'
    if args.adv_norm:
        exp_str+= '_AdvNrm'

    exp_dir = root_dir/exp_str
    exp_dir.mkdir(exist_ok=True)

    gamma = args.gamma
    iterations = args.iterations
    batch_size = args.batch

    env = gym.make(args.env)

    USE_GPU = FALSE
    if torch.cuda.is_available() and USE_GPU:
        dev = "cuda:0"
    else:
        dev = "cpu"
    device = torch.device(dev)

    pg_net = PolicyGradNet(env.observation_space.shape.prod(),env.action_space.n).to(device)
    opt = optim.Adam(pg_net.parameters(),lr = args.lr)
    torchify_state = lambda state: (torch.from_numpy(np.array(state).type(torch.FloatTensor))).unsqueeze(0)
    logger = init_logger(exp_str,exp_dir/f'{exp_str}.log')
    logger.info(f'intitializing exp: {exp_str}')
    dispatch_exp()
