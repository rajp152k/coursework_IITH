#include <linux/uaccess.h>
#include <linux/fs.h>
#include <linux/module.h>
#include <linux/slab.h>
#include <linux/mm.h>

#include <mydev.h>

MODULE_DESCRIPTION("My kernel module - mykmod");
MODULE_AUTHOR("maruthisi.inukonda [at] gmail.com");
MODULE_LICENSE("GPL");

// Dynamically allocate major no
#define MYKMOD_MAX_DEVS 256
#define MYKMOD_DEV_MAJOR 0

static int mykmod_init_module(void);
static void mykmod_cleanup_module(void);

static int mykmod_open(struct inode *inode, struct file *filp);
static int mykmod_close(struct inode *inode, struct file *filp);
static int mykmod_mmap(struct file *filp, struct vm_area_struct *vma);

module_init(mykmod_init_module);
module_exit(mykmod_cleanup_module);

static struct file_operations mykmod_fops = {
	.owner = THIS_MODULE,	/* owner (struct module *) */
	.open = mykmod_open,	/* open */
	.release = mykmod_close,	/* release */
	.mmap = mykmod_mmap,	/* mmap */
};

static void mykmod_vm_open(struct vm_area_struct *vma);
static void mykmod_vm_close(struct vm_area_struct *vma);
static int mykmod_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf);

//[x] TODO Data-structure to keep per device info 
struct dev_info {
	char *strg;
	int ref_count;
};				//strg is the start of the kernel logical address where the 1 MB is allocated using kmalloc
// ref_count is the number of files open, referencing to that inode

//[x] TODO Device table data-structure to keep all devices
struct dev_info *dev_table[256];	//a table of 256 pointers as the number of possible devices are limited to the number of possible minor numbers

//[x] TODO Data-structure to keep per VMA info 
struct vma_info {
	unsigned long npagef;	//number of page faults of that vm area
	struct dev_info *dev_i;	//pointer to private data of inode
};

static const struct vm_operations_struct mykmod_vm_ops = {
	.open = mykmod_vm_open,
	.close = mykmod_vm_close,
	.fault = mykmod_vm_fault
};

int mykmod_major;

static int mykmod_init_module(void)
{
	int i;
	printk("mykmod loaded\n");
	printk("mykmod initialized at=%p\n", init_module);

	if ((mykmod_major =
	     register_chrdev(MYKMOD_DEV_MAJOR, "mykmod", &mykmod_fops)) < 0) {
		printk(KERN_WARNING "Failed to register character device\n");
		return 1;
	} else {
		printk("register character device %d\n", mykmod_major);
	}
	//[x] TODO initialize device table
	for (i = 0; i < 256; i++) {
		dev_table[i] = NULL;
	}
	return 0;
}

static void mykmod_cleanup_module(void)
{
	int i;
	printk("mykmod unloaded\n");
	unregister_chrdev(mykmod_major, "mykmod");
	//[x] TODO free device info structures from device table
	for (i = 0; i < 256; i++) {
		if (dev_table[i] != NULL) {
			kfree(dev_table[i]->strg);
			kfree(dev_table[i]);
		};
	}
	return;
}

static int mykmod_open(struct inode *inodep, struct file *filep)
{
	printk("mykmod_open: filep=%p f->private_data=%p "
	       "inodep=%p i_private=%p i_rdev=%x maj:%d min:%d\n",
	       filep, filep->private_data,
	       inodep, inodep->i_private, inodep->i_rdev, MAJOR(inodep->i_rdev),
	       MINOR(inodep->i_rdev));

	//[x] TODO: Allocate memory for devinfo and store in device table and i_private.
	if (inodep->i_private == NULL) {	//allocating only if this is the first time that inode is being opened
		inodep->i_private =
		    (struct dev_info *)kmalloc(sizeof(struct dev_info),
					       GFP_KERNEL);
		((struct dev_info *)(inodep->i_private))->ref_count = 0;
	}			//Kmalloc flag as GFP_KERNEL as process should be allowed to sleep in case memory is not available (ATOMIC would waste resources/lead to spinlocks)

	//[x] Store device info in file's private_data aswell
	filep->private_data = inodep->i_private;
	(((struct dev_info *)(filep->private_data))->ref_count)++;
	dev_table[MINOR(inodep->i_rdev)] = inodep->i_private;

	return 0;
}

static int mykmod_close(struct inode *inodep, struct file *filep)
{
	//[x] TODO: Release memory allocated for data-structures.
	printk("mykmod_close: inodep=%p filep=%p\n", inodep, filep);
	(((struct dev_info *)(filep->private_data))->ref_count)--;
	if (((struct dev_info *)(inodep->i_private))->ref_count == 0) {
		kfree(((struct dev_info *)(inodep->i_private))->strg);
		kfree(inodep->i_private);
		dev_table[MINOR(inodep->i_rdev)] = NULL;
	}
	return 0;
}

static int mykmod_mmap(struct file *filp, struct vm_area_struct *vma)
{
	printk("mykmod_mmap: filp=%p vma=%p flags=%lx\n", filp, vma,
	       vma->vm_flags);

	//[x]TODO setup vma's flags, save private data (devinfo, npagefaults) in vm_private_data
	vma->vm_ops = &mykmod_vm_ops;
	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;	//as not going to mmap more than the 1 MB and don't want those pages to be snap-shot during kernel panic
	vma->vm_private_data =
	    (struct vma_info *)kmalloc(sizeof(struct vma_info), GFP_KERNEL);
	((struct vma_info *)(vma->vm_private_data))->dev_i = filp->private_data;
	((struct vma_info *)(vma->vm_private_data))->dev_i->strg = vma->vm_start;	//setting start of the storage to the vm_start and allocating the requested 1 MB of memory here
	((struct vma_info *)(vma->vm_private_data))->npagef = 0;
	mykmod_vm_open(vma);
	return 0;
}

static void mykmod_vm_open(struct vm_area_struct *vma)
{
	printk("mykmod_vm_open: vma=%p npagefaults:%lu\n", vma,
	       ((struct vma_info *)(vma->vm_private_data))->npagef);
}

static void mykmod_vm_close(struct vm_area_struct *vma)
{
	printk("mykmod_vm_close: vma=%p npagefaults:%lu\n", vma,
	       ((struct vma_info *)(vma->vm_private_data))->npagef);
	kfree(vma->vm_private_data);
}

static int mykmod_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
{
	//[x] TODO: build virt->phys mappings
	unsigned long offset = (vmf->pgoff) << PAGE_SHIFT;
	unsigned long physaddress =
	    (unsigned long)(vmf->virtual_address) - vma->vm_start + offset;
	printk("mykmod_vm_fault: vma=%p vmf=%p pgoff=%lu page=%p\n", vma, vmf,
	       vmf->pgoff, vmf->page);
	(((struct vma_info *)(vma->vm_private_data))->npagef)++;
	vmf->page = virt_to_page(physaddress);	//returns a page pointer to the concerned page
	return 0;
}
