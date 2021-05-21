import pandas as pd
import asyncio
import imdb
from tqdm import tqdm
import imdb


async def get_sites(ia,mid):
    try:
        sites = ia.get_movie_official_sites(mid[2:])['data']['official_sites']
    except KeyError:
        return "\\N"
    site_set = {s[1] for s in sites}
    return site_set.__repr__()

async def get_plots(ia,mid):
    try:
        plots= ia.get_movie_plot(mid[2:])['data']['plot']
    except KeyError:
        return "\\N"
    return {plots[0]}.__repr__()

async def writer_entries(f,q):
    while True:
        entry = await q.get()
        f.write(entry)
        #print(f'wrote entry {entry[:10]}...')
        q.task_done()

async def get_entries(ia,q,ids):
    for mid in tqdm(ids[:4000000:2000]):
        sites,plots = await asyncio.gather(get_sites(ia,mid), get_plots(ia,mid))
        #print(f'got entry {mid}')
        await q.put(f'{mid}\t{sites}\t{plots}\n')
         
async def main():
    ia = imdb.IMDb()
    ids = pd.read_pickle('id.p')
    q = asyncio.Queue()

    f = open('extra_info.tsv','w') 
    f.write('movie_id\tsites\tplots\n')

    producer = asyncio.create_task(get_entries(ia,q,ids))
    consumer = asyncio.create_task(writer_entries(f,q))
    await producer
    await q.join()
    consumer.cancel()

    f.close()

if __name__ == '__main__':
    asyncio.run(main())
